CREATE OR REPLACE TABLE `rakamin-kf-analytics-500910.kimia_farma.kf_analysis_table` AS

WITH base AS (
  #membuat tabel analisa dengan menggabungkan tabel transaksi dengan tabel cabang dan tabel produk
  SELECT
    t.transaction_id, #kode id transaksi
    t.date, #tanggal transaksi dilakukan
    t.branch_id, #kode id cabang Kimia Farma
    c.branch_name, #nama cabang Kimia Farma
    c.kota, #kota cabang Kimia Farma
    c.provinsi, #provinsi cabang Kimia Farma
    c.rating AS rating_cabang, #rating konsumen terhadap cabang
    t.customer_name, #nama customer yang melakukan transaksi
    t.product_id, #kode produk obat
    p.product_name, #nama obat
    t.price AS actual_price, #harga obat sebelum diskon
    t.discount_percentage, #persentase diskon
    t.rating AS rating_transaksi #rating konsumen terhadap transaksi
  FROM `rakamin-kf-analytics-500910.kimia_farma.kf_final_transaction` t
  LEFT JOIN `rakamin-kf-analytics-500910.kimia_farma.kf_kantor_cabang` c
    ON t.branch_id = c.branch_id
  LEFT JOIN `rakamin-kf-analytics-500910.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
),
#LEFT JOIN dipilih supaya semua baris transaksi tetap muncul
#walaupun ada product_id atau branch_id yang tidak match

calculated AS (
  #menghitung persentase_gross_laba berdasarkan tier harga obat sesuai ketentuan
  SELECT
    *,
    CASE
      WHEN actual_price <= 50000 THEN 0.10
      WHEN actual_price > 50000  AND actual_price <= 100000 THEN 0.15
      WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
      WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
      WHEN actual_price > 500000 THEN 0.30
      ELSE NULL
    END AS persentase_gross_laba #persentase laba yang seharusnya diterima dari obat
  FROM base
)

#menghitung nett_sales dan nett_profit, lalu menyusun ulang kolom sesuai urutan mandatory yang diminta
SELECT
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  persentase_gross_laba,
  #nett_sales = harga setelah dikurangi diskon
  ROUND(actual_price * (1 - discount_percentage)) AS nett_sales,
  #nett_profit = nett_sales dikali persentase gross laba
  ROUND(actual_price * (1 - discount_percentage) * persentase_gross_laba) AS nett_profit,
  rating_transaksi
FROM calculated;

#VALIDASI HASIL
#cek jumlah baris hasil tabel analisa vs jumlah baris tabel transaksi asli
#(harusnya sama, kecuali ada duplikasi karena join)
SELECT COUNT(*) AS total_baris_analysis_table
FROM `rakamin-kf-analytics-500910.kimia_farma.kf_analysis_table`;

SELECT COUNT(*) AS total_baris_transaction
FROM `rakamin-kf-analytics-500910.kimia_farma.kf_analysis_table`;

#cek apakah ada baris dengan branch_name atau product_name NULL
#(indikasi ada branch_id/product_id yang tidak match saat JOIN)
SELECT *
FROM `rakamin-kf-analytics-500910.kimia_farma.kf_analysis_table`
WHERE branch_name IS NULL OR product_name IS NULL;


SELECT *
FROM `rakamin-kf-analytics-500910.kimia_farma.kf_analysis_table`
LIMIT 100;