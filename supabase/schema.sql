-- ============================================================================
-- ENGLISH MASTER 9+ (ÔN THI VÀO 10 ĐỀ THANH HÓA) - SUPABASE DATABASE SCHEMA
-- Hỗ trợ đồng bộ đa thiết bị (Multi-device Cloud Sync) theo thời gian thực
-- ============================================================================

-- Kích hoạt extension tạo UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. BẢNG USERS (PROFILES) - Mở rộng từ bảng auth.users của Supabase
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT DEFAULT 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
    target_school TEXT DEFAULT 'THPT Chuyên Lam Sơn / THPT Công lập Thanh Hóa',
    target_score NUMERIC(3,1) DEFAULT 9.2,
    streak_days INTEGER DEFAULT 1,
    last_active_device TEXT DEFAULT 'Desktop Web',
    last_synced_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.users IS 'Thông tin hồ sơ học sinh, mục tiêu điểm số và trạng thái đồng bộ thiết bị gần nhất.';

-- ============================================================================
-- 2. BẢNG USER_PROGRESS - Lưu tiến độ học tập từng bài học & chuyên đề
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    course_id TEXT NOT NULL,           -- Mã chuyên đề (VD: 'gd1-cd1', 'gd2-cd1', 'gd3-cd6')
    lesson_id TEXT NOT NULL,           -- Mã bài học (VD: 'gd1-cd1-theory', 'gd1-hp1-exercise')
    stage_id TEXT NOT NULL,            -- 'stage-1' | 'stage-2' | 'stage-3'
    status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
    completion_percent INTEGER NOT NULL DEFAULT 0 CHECK (completion_percent >= 0 AND completion_percent <= 100),
    quiz_score NUMERIC(4,1) DEFAULT NULL,       -- Điểm bài tập vận dụng (thang 10)
    correct_answers INTEGER DEFAULT 0,
    total_questions INTEGER DEFAULT 0,
    time_spent_seconds INTEGER DEFAULT 0,
    bookmarked BOOLEAN DEFAULT FALSE,
    user_notes TEXT DEFAULT '',
    device_updated TEXT DEFAULT 'Web Client',
    last_accessed_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, lesson_id)
);

COMMENT ON TABLE public.user_progress IS 'Đồng bộ tiến độ từng bài học (Lý thuyết, Flashcard, Bài tập, Đáp án), điểm số và ghi chú cá nhân.';

-- Tạo Index tăng tốc truy vấn khi đồng bộ chéo thiết bị
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON public.user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_course_id ON public.user_progress(user_id, course_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_stage_id ON public.user_progress(user_id, stage_id);

-- ============================================================================
-- 3. BẢNG FLASHCARD_STATS - Lưu thống kê học Flashcard & Typing Practice (SRS)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.flashcard_stats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    card_id TEXT NOT NULL,             -- Mã thẻ từ vựng / công thức / idiom / word family
    course_id TEXT NOT NULL,           -- Thuộc chuyên đề nào
    stage_id TEXT NOT NULL,            -- 'stage-1' | 'stage-2' | 'stage-3'
    mastery_level TEXT NOT NULL DEFAULT 'new' CHECK (mastery_level IN ('new', 'learning', 'reviewing', 'mastered')),
    box_number INTEGER NOT NULL DEFAULT 1 CHECK (box_number >= 1 AND box_number <= 5), -- Leitner System Box 1-5
    review_count INTEGER NOT NULL DEFAULT 0,
    correct_streak INTEGER NOT NULL DEFAULT 0,
    typing_accuracy NUMERIC(5,2) DEFAULT 100.0,
    last_reviewed_at TIMESTAMPTZ DEFAULT NOW(),
    next_review_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, card_id)
);

COMMENT ON TABLE public.flashcard_stats IS 'Lưu trạng thái ghi nhớ từng thẻ Flashcard (Quy tắc phát âm, 35 Gia đình từ, 40 Phrasal Verbs, 40 Idioms) theo thuật toán lặp lại ngắt quãng.';

CREATE INDEX IF NOT EXISTS idx_flashcard_stats_user_id ON public.flashcard_stats(user_id);
CREATE INDEX IF NOT EXISTS idx_flashcard_stats_next_review ON public.flashcard_stats(user_id, next_review_at);

-- ============================================================================
-- 4. CƠ CHẾ TỰ ĐỘNG CẬP NHẬT UPDATED_AT & ĐỒNG BỘ REALTIME
-- ============================================================================
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_users_updated_at ON public.users;
CREATE TRIGGER set_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS set_user_progress_updated_at ON public.user_progress;
CREATE TRIGGER set_user_progress_updated_at
    BEFORE UPDATE ON public.user_progress
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS set_flashcard_stats_updated_at ON public.flashcard_stats;
CREATE TRIGGER set_flashcard_stats_updated_at
    BEFORE UPDATE ON public.flashcard_stats
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Tự động tạo bản ghi trong public.users khi người dùng Đăng ký qua Supabase Auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, full_name, avatar_url)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'avatar_url', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- 5. BẢO MẬT ROW LEVEL SECURITY (RLS) CHO ĐỒNG BỘ CÁ NHÂN
-- ============================================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.flashcard_stats ENABLE ROW LEVEL SECURITY;

-- Policies cho bảng users
CREATE POLICY "Users can view own profile"
    ON public.users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.users FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.users FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Policies cho bảng user_progress
CREATE POLICY "Users can view own progress"
    ON public.user_progress FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress"
    ON public.user_progress FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
    ON public.user_progress FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own progress"
    ON public.user_progress FOR DELETE
    USING (auth.uid() = user_id);

-- Policies cho bảng flashcard_stats
CREATE POLICY "Users can view own flashcard stats"
    ON public.flashcard_stats FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own flashcard stats"
    ON public.flashcard_stats FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own flashcard stats"
    ON public.flashcard_stats FOR UPDATE
    USING (auth.uid() = user_id);

-- Bật Supabase Realtime cho 2 bảng tiến độ để tự động đẩy dữ liệu sang thiết bị khác
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_progress;
ALTER PUBLICATION supabase_realtime ADD TABLE public.flashcard_stats;
