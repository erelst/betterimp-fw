---
name: isolation-debug
description: >
  Incremental Isolation Debugging (Binary Search Debugging) — teknik debug
  sistematis dengan mempersempit area error secara bertahap seperti binary
  search. Trigger: user bilang "binary search debug", "isolation debug",
  "script error tapi nggak tahu baris mana", "error di file besar", "syntax
  error susah nemu", "import error tracing".
argument-hint: "[baseline|bisect|trace]"
license: MIT
---

# Incremental Isolation Debugging

Teknik debug sistematis: buat baseline yang works, tambah kode bertahap, test
setiap penambahan. Seperti binary search — mempersempit area yang menyebabkan
error.

## Kapan Pakai

- Script evaluation error (seperti SW/script error)
- Function tidak jalan tapi tidak tahu baris mana yang error
- Syntax error di file besar
- Import/dependency error
- Error yang tidak jelas source-nya
- User mengirim kode error atau warning

## Langkah Praktis

1. **Buat baseline** — File minimal yang tidak error (copy file, hapus sebagian besar kode)
2. **Copy sebagian kecil** dari file yang error ke baseline
3. **Test** — jika works, tambah lagi. Jika gagal, rollback dan cari di bagian yang baru ditambah
4. **Ulangi** sampai ketemu baris/fungsi penyebab error

### Binary Search Variant (lebih cepat)

1. Copy file error ke `debug-v1.js`
2. Hapus **setengah** kode → test
3. Jika works → error di setengah yang dihapus
4. Jika fails → error di setengah yang tersisa
5. Ulangi sampai ketemu baris/fungsi penyebab error

## Output Format

```
Baseline: [file] — works
Added: [section/function] — works/fails
→ Error di: [specific line/function]
Root cause: [explanation]
```

## Contoh

User: "SW saya error tapi nggak tahu baris mana"

AI: "Pakai isolation debug. Buat `sw-debug-v1.js`, copy SW kamu, hapus setengah kode, test. Ulangi sampai nemu."

## Tips

- Mulai dengan file kosong + import minimal (baseline works)
- Tambah per function/per section, bukan per baris
- Simpan setiap milestone yang works (versioning manual: v1, v2, ...)
- Untuk syntax error: hapus setengah file, lihat error hilang atau nggak
- Untuk runtime error: tambah kode sampai error muncul

## Batasan

Teknik ini manual, bukan otomatis. Butuh waktu tapi akurat untuk error yang
susah dilacak dengan log biasa.
