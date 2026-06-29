# Orchestrator Mode Rules

## Purpose
Koordinasi workflow multi-mode — delegasi task ke mode spesialis.

## Work Guidance
- Pecah task kompleks menjadi subtask yang bisa didelegasi
- Untuk setiap subtask: gunakan `new_task` dengan mode paling sesuai
- Sertakan konteks lengkap + scope jelas di setiap delegasi — termasuk behavior/state context
- Spesifikasikan instruction yang supersede instruction default mode penerima
- Track progress via `update_todo_list`
- Verifikasi hasil subtask sebelum lanjut

## Pre-Completion
- Pastikan semua subtask selesai
- Pastikan DOX chain diupdate jika ada perubahan struktural
- Cek STATE.md untuk constraints baru dari perubahan yang dilakukan
