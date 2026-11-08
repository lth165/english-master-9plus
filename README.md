# 🎓 English Master 9+ — Hệ Thống Tự Học Tiếng Anh Vào 10 (Đề Thanh Hóa)

Website tự học Tiếng Anh cá nhân hướng tới mục tiêu **9+ trong kỳ thi tuyển sinh vào lớp 10 (chuẩn cấu trúc Đề Thanh Hóa)**, lấy cảm hứng thiết kế từ giao diện **Modern Educational Dashboard (Growly UI)** và tích hợp **Đồng bộ tiến độ đa thiết bị (Cloud Sync)** qua **Supabase**.

---

## ✨ Điểm nổi bật của Dự án

1. **Dữ liệu học thuật chuẩn 100% từ Tài liệu Word chính thức (Không dùng Lorem Ipsum):**
   - **Giai đoạn 1 – Nền tảng (11 Chuyên đề / 3 Học phần):** Ngữ âm cơ bản (-s/-es, -ed, Âm câm SGK 8-9, Trọng âm 2 âm tiết), Hệ thống 9 Thì & Sự phối hợp thì, V-ing / to V / V(bare), Câu bị động, Câu điều kiện & Wish, Câu trực tiếp – gián tiếp, Mệnh đề quan hệ, Các cấp độ So sánh & So sánh kép, Mạo từ – Giới từ – Lượng từ, Chức năng giao tiếp, Kỹ năng đọc hiểu cơ bản (Làng đá mỹ nghệ Non Nước – nghệ nhân Huỳnh Bá Quát quê Thanh Hóa).
   - **Giai đoạn 2 – Lấp lỗ hổng & Tăng tốc 8–9 điểm (4 Chuyên đề):** Trọng âm 3 âm tiết, Bí quyết phân tích vị trí Từ loại, Bảng 35 Gia đình từ (Word Families), 8 cặp Tính từ dễ nhầm lẫn, Hòa hợp S-V, Nhượng bộ/Kết quả, Rút gọn MĐQH, Câu hỏi đuôi, OSASCOMP, 40 Phrasal Verbs Lớp 9 Mới, Collocations & 12 công thức chuyển đổi cụm tương đương.
   - **Giai đoạn 3 – Ép điểm 9+ & Chống sai ngu (7 Chuyên đề):** 12 tính từ đuôi `-ed` đọc `/ɪd/`, Bảng 40 Thành ngữ (Idioms), Modal Perfect & `Having + Vp2`, Câu bị động đặc biệt (Causative & Impersonal Passive lệch thì), Điều kiện hỗn hợp & Thể giả định (`It's high time`, `Would rather`), Tường thuật với động từ đặc biệt, 7 nhóm Đảo ngữ toàn diện & **Checklist "5 Phút Vàng"**.

2. **Kiến trúc Component tái sử dụng chuẩn chỉnh:**
   - `Sidebar` (7 mục điều hướng cố định trái, thu gọn được trên Desktop & Drawer trên Mobile)
   - `DashboardHeader` (Lời chào cá nhân hóa, Tìm kiếm tức thời, Trạng thái Cloud Sync, Tài khoản User)
   - `AuthModal` (Popup Đăng nhập / Đăng ký / Kiểm tra trạng thái đồng bộ chéo Điện thoại & Máy tính)
   - `CategoryTabs` (`Tất cả | Giai đoạn 1 – Nền tảng | Giai đoạn 2 – Tăng tốc | Giai đoạn 3 – Chinh phục 9+`)
   - `CourseCard` (Thẻ chuyên đề màu Pastel kèm số bài học, % hoàn thành, điểm số & nút Tiếp tục học)
   - `LessonList` (Danh sách 4 bài học của từng chuyên đề: Lý thuyết, Flashcard, Bài tập, Đáp án)
   - `ProgressWidget` (Thanh tiến độ kẻ sọc chéo đặc trưng từ ảnh mẫu `image_fbc802.jpg`)
   - `DailyReviewWidget` (Flashcard lật mặt tương tác + phát âm Web Speech API ngay tại Sidebar phải)
   - `ExamTipWidget` (Thẻ Mẹo phòng thi Thanh Hóa màu `#3B36F4` nổi bật)
   - `LessonModal` (Trình học tập đa năng: Bảng lý thuyết, Ghi chú Cloud, Luyện gõ Flashcard, Chấm điểm Bài tập tự động & Đáp án giải thích chi tiết)

---

## 🚀 Cách 1: Chạy thử NGAY LẬP TỨC (Không cần cài đặt Node.js)

Nếu máy tính của bạn chưa cài đặt Node.js, bạn có thể trải nghiệm toàn bộ ứng dụng React ngay lập tức:
1. Mở thư mục dự án: `C:\Users\Admin\.gemini\antigravity\scratch\english-master-9plus`
2. Nhấp đúp chuột vào file **`preview.html`** để mở bằng trình duyệt (Chrome, Edge, Safari...).
3. Toàn bộ giao diện Dashboard, 22 Chuyên đề, Bài tập tự chấm điểm, Flashcard phát âm và Giả lập đồng bộ đa thiết bị sẽ hoạt động ngay!

---

## 💻 Cách 2: Chạy môi trường Development chuẩn (Vite + React + TypeScript)

Khi bạn đã cài đặt [Node.js](https://nodejs.org/) (phiên bản 18 trở lên):

```bash
# 1. Di chuyển vào thư mục dự án
cd C:\Users\Admin\.gemini\antigravity\scratch\english-master-9plus

# 2. Cài đặt các thư viện (React, TypeScript, Tailwind CSS, Lucide Icons, Supabase JS)
npm install

# 3. Khởi động máy chủ phát triển
npm run dev
```
Sau đó mở trình duyệt tại địa chỉ `http://localhost:5173`.

---

## ☁️ Hướng dẫn đấu nối API thật với Supabase (Đồng bộ Điện thoại & Máy tính)

Dự án đã chuẩn bị sẵn toàn bộ câu lệnh tạo bảng và phân quyền bảo mật tại file [`supabase/schema.sql`](./supabase/schema.sql) cùng module kết nối tại [`src/lib/supabaseClient.ts`](./src/lib/supabaseClient.ts).

### Bước 1: Tạo Project trên Supabase
1. Truy cập [https://supabase.com](https://supabase.com) và đăng nhập tài khoản miễn phí.
2. Nhấn **New Project**, đặt tên là `english-master-9plus`.

### Bước 2: Chạy file Database Schema
1. Trong bảng điều khiển Supabase, chọn mục **SQL Editor** ở thanh bên trái -> Nhấn **New Query**.
2. Mở file [`supabase/schema.sql`](./supabase/schema.sql), sao chép toàn bộ nội dung và dán vào SQL Editor.
3. Nhấn **Run** (hoặc `Ctrl + Enter`). Hệ thống sẽ tự động khởi tạo:
   - Bảng `public.users` (Lưu hồ sơ học sinh, trường mục tiêu, chuỗi ngày học `streak_days`, thiết bị đồng bộ).
   - Bảng `public.user_progress` (Lưu trạng thái từng bài học, `% hoàn thành`, `quiz_score`, ghi chú cá nhân).
   - Bảng `public.flashcard_stats` (Lưu cấp độ thuộc thẻ Leitner Box 1–5 và độ chính xác Typing Practice).
   - Các chính sách bảo mật **Row Level Security (RLS)** và **Supabase Realtime**.

### Bước 3: Điền API Key vào dự án
1. Trên Supabase, vào **Project Settings** -> **API**.
2. Sao chép **Project URL** và **anon public key**.
3. Đổi tên file `.env.example` thành `.env` và dán thông tin vào:
   ```env
   VITE_SUPABASE_URL=https://xyzcompany.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
4. Khởi động lại `npm run dev` — hệ thống sẽ tự động chuyển từ *Cloud Simulator* sang **Supabase Cloud thật**!
