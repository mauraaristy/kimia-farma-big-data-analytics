# Kimia Farma - Big Data Analytics Final Task

Project ini merupakan Final Task dari program Project-Based Internship **Big Data Analyst di PT Kimia Farma** yang diselenggarakan oleh **Rakamin Academy**.

## 📋 Deskripsi Project

Sebagai Big Data Analytics Intern, tugas utama project ini adalah mengevaluasi kinerja bisnis Kimia Farma periode 2020-2023 menggunakan data transaksi, cabang, produk, dan inventory. Hasil akhirnya berupa data pipeline dari BigQuery hingga dashboard interaktif di Google Looker Studio.

## 🎯 Problem Statement

Bagaimana performa penjualan dan profitabilitas Kimia Farma dari tahun ke tahun, cabang/provinsi mana yang menjadi kontributor utama maupun yang butuh perhatian, serta strategi apa yang bisa direkomendasikan untuk mendorong pertumbuhan bisnis berdasarkan data 2020-2023?

## 🗂️ Dataset yang Digunakan
| Nama Tabel | Deskripsi |
|---|---|
| `kf_final_transaction` | Data transaksi penjualan (transaction_id, product_id, branch_id, customer_name, date, price, discount_percentage, rating) |
| `kf_product` | Data master produk obat (product_id, product_name, product_category, price) |
| `kf_kantor_cabang` | Data master kantor cabang (branch_id, branch_category, branch_name, kota, provinsi, rating) |
| `kf_inventory` | Data stok produk per cabang (inventory_ID, branch_id, product_id, product_name, opname_stock) |

Dataset asli disediakan oleh Rakamin Academy & Kimia Farma dalam format CSV, kemudian diimpor ke Google BigQuery pada project `Rakamin KF Analytics`, dataset `kimia_farma`.

## 🛠️ Tools

- **Google BigQuery** — data warehousing & transformasi data
- **Google Looker Studio** — visualisasi dashboard

## 🧱 Struktur Tabel Analisa (`kf_analysis_table`)
Tabel hasil agregasi dari 3 tabel (`kf_final_transaction`, `kf_product`, `kf_kantor_cabang`) dengan kolom berikut:

- `transaction_id` – kode id transaksi
- `date` – tanggal transaksi
- `branch_id` – kode id cabang
- `branch_name` – nama cabang
- `kota` – kota cabang
- `provinsi` – provinsi cabang
- `rating_cabang` – rating konsumen terhadap cabang
- `customer_name` – nama customer
- `product_id` – kode produk obat
- `product_name` – nama obat
- `actual_price` – harga obat sebelum diskon
- `discount_percentage` – persentase diskon
- `persentase_gross_laba` – persentase laba berdasarkan tier harga
- `nett_sales` – harga setelah diskon
- `nett_profit` – keuntungan Kimia Farma
- `rating_transaksi` – rating konsumen terhadap transaksi

## 🔍 Proses Pengerjaan

1. **Importing Dataset ke BigQuery** — Keempat dataset diimport sebagai native table di dataset `kimia_farma` menggunakan fitur Create Table > Upload dengan auto-detect schema.
2. **Membuat Tabel Analisa** — Tabel `kf_analysis_table` dibangun dengan menggabungkan tabel transaksi, cabang, dan produk menggunakan `LEFT JOIN`, dilengkapi kolom turunan `persentase_gross_laba`, `nett_sales`, dan `nett_profit`. Query lengkap ada di [`kf_analysis_table.sql`](./kf_analysis_table.sql).
3. **Membuat Dashboard** — Dashboard performance analytics dibangun di Google Looker Studio, terhubung langsung ke `kf_analysis_table`.

## 📊 Dashboard

🔗 Link dashboard: **https://bit.ly/kimia-farma-performance-analytics-dashboard-PBIMaura**

## 💡 Key Insights

- Revenue Kimia Farma relatif stagnan di kisaran Rp80B/tahun sepanjang 2020-2023.
- Jawa Barat mendominasi ±30% dari total transaksi dan nett sales.
- Ditemukan gap antara rating cabang dan rating transaksi di 5 cabang, mayoritas berlokasi di luar Jawa.
- Tier harga premium (>Rp500rb) menjadi kontributor volume dan profit terbesar (±80% dari total nett profit).

## 📌 Rekomendasi

- Ekspansi ke provinsi dengan kontribusi rendah untuk mengurangi ketergantungan pada Jawa Barat.
- Audit operasional di cabang dengan gap rating tinggi.
- Prioritaskan inventory dan marketing untuk produk tier premium.
- Investigasi penyebab stagnasi 2023, apakah ada tekanan kompetitor (apotek online, e-commerce farmasi) yang menggerus pertumbuhan meski rating pelanggan tetap stabil di 4.0.

## 🎥 Video Presentasi

🔗 Link video: **(menyusul)**

## 👩‍💻 Author

**Maura Aristy**
Big Data Analytics Intern - Rakamin x Kimia Farma
[LinkedIn](https://linkedin.com/in/maura-aristy) | mathemauraa@gmail.com
