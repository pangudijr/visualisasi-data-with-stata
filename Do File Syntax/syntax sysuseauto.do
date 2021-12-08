sysuse auto
/*
mileage (mpg) = jarak tempuh
make = model mobil produk
price = harga
rep78 = catatan perbaikan
headroom = luas ruang utama
 trunk = ruang bagasi
 weight = berat
 length = panjang
 turn = berbelok displacement gear_ratio foreign

*/

histogram mpg, width(5) freq kdensity kdenopts(bwidth(5))
kdensity mpg, bwidth(3)