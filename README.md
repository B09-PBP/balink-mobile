# Balink : Linking your road with Balink! 🚗🔗

**BaLink** hadir sebagai solusi cerdas untuk kebutuhan transportasi Anda, menghubungkan setiap langkah perjalanan dengan pengalaman yang tak terlupakan.

**Balink dapat diakses secara langsung melalui ponsel.**

> Proyek ini dibuat untuk memenuhi tugas Proyek Akhir Semester (PAS)
> pada mata kuliah Pemrograman Berbasis Platform yang
> diselenggarakan oleh Fakultas Ilmu Komputer, Universitas Indonesia
> pada Semester Gasal, Tahun Ajaran 2024/2025.

## 📱 Aplikasi 📱

Saat ini, hanya tersedia versi Android (APK) untuk diunduh.

- App center: https://install.appcenter.ms/orgs/balink-mobile/apps/balink/distribution_groups/public
- GitHub Release: https://github.com/B09-PBP/balink-mobile/releases/tag/1.0.0%2B1

## Anggota Kelompok

- [Nevin Thang](https://github.com/Noc-art) - 2306203204
- [Mawla Raditya Pambudi](https://github.com/mawlaraditya) - 2306275323
- [Nabilah Roslita Utami](https://github.com/nabilahru) - 2306223446
- [Shabrina Aulia Kinanti](https://github.com/shabrinaulia) - 2306245472
- [Shaine Glorvina Mathea](https://github.com/glorvibop) - 2306245573

## Filosofi BaLink : Menghubungkan Perjalanan Anda dengan BaLink

Nama **BaLink** berasal dari kata “Bali” dan “Link” yang berarti penghubung. **BaLink** adalah aplikasi rental mobil di Denpasar yang dilengkapi dengan berbagai fitur untuk memudahkan wisatawan menemukan dan menyewa kendaraan dengan cepat dan mudah. BaLink berperan sebagai penghubung antara wisatawan dari Denpasar dan kebutuhan transportasi mereka selama menjelajahi Bali. BaLink diibaratkan sebagai kendaraan yang mengantarkan pengguna menuju petualangan dan pengalaman baru di setiap sudut Bali. Dengan BaLink, pengguna dapat merasakan kemudahan dalam menyewa kendaraan yang akan membantu mereka menemukan keindahan Pulau Dewata. BaLink dirancang untuk menjadi solusi transportasi yang praktis dan nyaman bagi semua wisatawan yang ingin berkeliling Bali dengan mudah.

Manfaat dari adanya BaLink adalah sebagai berikut:

- Menyediakan berbagai pilihan mobil berkualitas dengan harga kompetitif.
- Fitur yang memudahkan pengguna untuk memilih, menyimpan, dan menyewa mobil.
- Pengalaman yang lebih nyaman dengan adanya fitur bookmark dan keranjang.
- Memungkinkan pengguna berbagi pengalaman melalui fitur review, membantu wisatawan lain memilih kendaraan yang tepat.
- BaLink membantu wisatawan merencanakan perjalanan mereka dengan lebih baik, memastikan mobil tersedia saat dibutuhkan.

## 🔗 Integrasi dengan Situs Web 🔗

Berikut adalah langkah-langkah yang akan dilakukan untuk mengintegrasikan aplikasi dengan server web:

1. Mengimplementasikan sebuah _wrapper class_ dengan menggunakan library _http_ dan _map_ untuk mendukung penggunaan _cookie-based authentication_ pada aplikasi.
2. Mengimplementasikan REST API pada Django (views.<area>py) dengan menggunakan JsonResponse atau Django JSON Serializer.
3. Mengimplementasikan desain _front-end_ untuk aplikasi berdasarkan desain website yang sudah ada sebelumnya.
4. Melakukan integrasi antara _front-end_ dengan _back-end_ dengan menggunakan konsep _asynchronous_ HTTP.

## 🗂️ Daftar Modul 🗂️

### 🚗 **Product Page**

**Dikerjakan oleh Nevin Thang**

Halaman ini menampilkan katalog mobil dengan detail seperti harga, kapasitas, dan fitur lainnya. Pengguna dapat melihat mobil populer (Best Seller), menyaring mobil (Filtering), dan menambah mobil ke keranjang.

### Alur pengintegrasian dengan web service :

#### Customer:

1. Melihat Katalog: `GET /api/cars` untuk menampilkan daftar mobil.
2. Filtering: `GET /api/cars?filter={params}` untuk menyaring mobil.
3. Tambah ke Keranjang: `POST /api/cart` untuk menambahkan mobil ke keranjang.

#### Admin:

1. Tambah mobil: `POST /api/cars` untuk menambahkan data mobil baru ke katalog.
2. Edit mobil: `PUT /api/cars/{id}` untuk mengedit data mobil yang ada.
3. Hapus mobil: `DELETE /api/cars/{id}` untuk menghapus data mobil dari katalog.

### Aksi yang dapat dilakukan untuk Pengguna dan Admin :

| **Customer**                                                                                                                                                                | **Admin**                                                                                                                     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Customer dapat melihat katalog mobil dan mencari mobil berdasarkan filter seperti harga dan kapasitas penumpang dan dapat menambahkan mobil yang ingin disewa ke keranjang. | Admin dapat menambahkan, mengedit, atau menghapus mobil dari katalog dan mengelola daftar mobil yang muncul di halaman utama. |

### 🛒 **Cart**

**Dikerjakan oleh Shabrina Aulia Kinanti**

Setelah memilih mobil dari katalog, pengguna dapat menambahkannya ke Cart (keranjang). Di sini, pengguna dapat mengelola mobil yang ingin mereka sewa, melihat total biaya penyewaan, dan melanjutkan ke proses checkout untuk menyelesaikan transaksi. Pengguna juga bisa menghapus mobil dari keranjang jika berubah pikiran.

### Alur pengintegrasian dengan web service :

#### Customer:

1. Menambahkan ke Keranjang: `POST /api/cart` untuk menambahkan mobil ke keranjang dengan mengirim data mobil yang dipilih.
2. Melihat Keranjang: `GET /api/cart` untuk menampilkan daftar mobil yang ada di keranjang dan total biaya.
3. Menghapus dari Keranjang: `DELETE /api/cart/{id}` untuk menghapus mobil tertentu dari keranjang.
4. Checkout: `POST /api/checkout` untuk menyelesaikan transaksi dan menyimpan data pesanan ke database.

#### Admin

1. Melihat Semua Pesanan: `GET /api/orders` untuk memantau semua pesanan yang telah dibuat oleh pengguna.

### Aksi yang dapat dilakukan untuk Pengguna dan Admin :

| **Customer**                                                                                                        | **Admin**                          |
| ------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| Customer dapat Menambahkan mobil ke keranjang untuk disewa, melakukan penyewaan, dan menghapus mobil dari keranjang | Admin dapat memantau semua pesanan |

### 🛵 **Place To Go**

**Dikerjakan oleh Mawla Raditya Pambudi**

Layanan Place To Go memungkinkan pengguna untuk menemukan rekomendasi tempat-tempat menarik di sekitar area Bali yang dapat mereka kunjungi selama perjalanan. BaLink akan menampilkan lokasi wisata, restoran, dan spot populer yang direkomendasikan kepada pengguna berdasarkan lokasi mereka atau berdasarkan kategori pilihan, seperti wisata alam, kuliner, dan tempat belanja.

### Alur pengintegrasian dengan web service :

#### Customer:

1. Melihat Rekomendasi Tempat: `GET /api/places` untuk enampilkan daftar tempat menarik yang direkomendasikan.

#### Admin

1. Memperbarui Informasi Tempat: `PUT /api/places/{id}` untuk mengedit informasi tempat.
2. Menghapus Tempat: `DELETE /api/places/{id}` untuk menghapus data tempat dari daftar rekomendasi.

### Aksi yang dapat dilakukan untuk Pengguna dan Admin :

| **Customer**                                                       | **Admin**                                       |
| ------------------------------------------------------------------ | ----------------------------------------------- |
| Customer dapat melihat tempat-tempat menarik yang direkomendasikan | Admin dapat mengedit atau memperbarui informasi |

### ⭐️ **Review**

**Dikerjakan oleh Nabilah Roslita Utami**

Fitur Review memungkinkan pengguna untuk memberikan ulasan mengenai mobil yang telah mereka sewa. Pengguna lain dapat membaca ulasan tersebut sebagai referensi sebelum menyewa mobil. Fitur ini membantu wisatawan membuat keputusan yang lebih baik berdasarkan pengalaman pengguna lain.

### Alur pengintegrasian dengan web service :

#### Customer:

1. Memberikan Ulasan: `POST /api/reviews` untuk menambahkan ulasan dan rating terhadap mobil yang telah disewa.
2. Melihat Ulasan: `GET /api/reviews/{car_id}` untuk membaca ulasan dan rating dari pengguna lain untuk mobil tertentu.

#### Admin

1. Meninjau Ulasan: `GET /api/reviews` untuk melihat daftar semua ulasan yang diberikan oleh pengguna.
2. Menghapus Ulasan: `DELETE /api/reviews/{id}` untuk menghapus ulasan yang tidak sesuai dengan kebijakan.

### Aksi yang dapat dilakukan untuk Pengguna dan Admin :

| **Customer**                                                                                                                                                             | **Admin**                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| Customer dapat memberikan ulasan dan rating terhadap mobil yang telah disewa dan membaca ulasan dan referensi dari pengguna lain sebelum memutuskan untuk menyewa mobil. | Admin dapat meninjau ulasan dan Menghapus ulasan yang tidak sesuai dengan kebijakan. |

### 🔖 **Bookmark**

**Dikerjakan oleh Shaine Glorvina Mathea**

Bookmark memungkinkan pengguna menyimpan mobil atau tempat favorit yang mereka lihat di BaLink untuk dilihat di kemudian hari. Dengan fitur ini, pengguna bisa dengan mudah menandai mobil yang ingin mereka sewa atau tempat yang ingin mereka kunjungi nanti, tanpa perlu mencarinya kembali.

### Alur pengintegrasian dengan web service :

#### Customer:

1. Menyimpan ke Bookmark: `POST /api/bookmarks` untuk menyimpan mobil atau tempat favorit ke dalam daftar bookmark.
2. Melihat Bookmark: `GET /api/bookmark`s untuk melihat daftar item yang telah disimpan di bookmark.
3. Menghapus Bookmark: `DELETE /api/bookmarks/{id}` untuk menghapus item tertentu dari daftar bookmark.

#### Admin

1. Melihat Statistik Bookmark: `GET /api/bookmarks/stats` untuk melihat statistik penggunaan fitur bookmark oleh pengguna.

### Aksi yang dapat dilakukan untuk Pengguna dan Admin :

| **Customer**                                                                                                                               | **Admin**                                                             |
| ------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| Customer dapat menyimpan mobil atau tempat yang diinginkan ke dalam daftar bookmark dan mengelola item di dalam daftar bookmark kapan saja | Admin dapat melihat statistik penggunaan fitur bookmark oleh pengguna |

## 🙎‍♀️ Peran Pengguna 🙎‍♂️

Aplikasi BaLink memiliki dua tipe pengguna, yaitu:

### Admin

Admin memiliki full-access terhadap seluruh fitur aplikasi, seperti :

- Menambah, mengedit, dan menghapus produk mobil yang tersedia.
- Mengelola konten promosi yang ditampilkan di aplikasi.
- Memantau dan memoderasi ulasan yang diberikan oleh customer.
- Memantau dan mengelola transaksi penyewaan mobil.
- Menambahkan artikel dalam page "Place to Go"

### Customer

Customer memiliki akses terbatas untuk menggunakan fitur penyewaan mobil, seperti :

- Melihat katalog mobil, menggunakan filter, dan memilih mobil untuk disewa.
- Membaca artikel dalam page "Place to Go"
- Menyimpan mobil favorit ke dalam bookmark.
- Menambahkan mobil ke keranjang dan melanjutkan ke proses penyewaan.
- Memberikan ulasan dan rating terhadap mobil yang telah disewa.

Penjelasan lebih lengkap dapat dilihat pada daftar modul yang tersedia
