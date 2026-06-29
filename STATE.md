# State & Constraints

## Anti-Regresi / Strict Constraints
*(Isi dengan constraint yang harus dijaga dari regresi)*

Contoh:
- `src/domain/` — logika bisnis inti, tidak boleh tambah dependensi framework
- `config/database.ts` — kredensial database, jangan commit tanpa .env
- `.env` — tidak boleh masuk version control, sudah di .gitignore

## Entry Log
*(Catat setiap perubahan signifikan — kondisi/perilaku/state sebelum & sesudah)*

| Tanggal (YYYY-MM-DD HH:mm) | Perubahan | Pelaku |
|----------------------------|-----------|--------|
| YYYY-MM-DD HH:mm | Deskripsi: [kondisi] → [tindakan] → [hasil]. State sebelum: X, state sesudah: Y. | Nama |
