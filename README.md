# MariaDB_backup
Снятие дампа БД MariaBD
Для удобства бэкапы будут сниматься на подключаемый к ВМ диск.
#### Шаг 1 - Подключение диска бэкапы. 
После Физического подключерия к ВМ нам необходимо: <br>
Найти новый диск:

```
sudo lsblk -f
```
Создать файловую систему:
```
sudo fdisk /dev/sdb
```
В fdisk:
```
n → Enter (новый раздел)
p → Enter (primary)
1 → Enter (первый раздел)
Enter → Enter (весь диск)
w → Enter (сохранить)
```
Форматируем:
```
sudo mkfs.ext4 /dev/sdb1
```
Примонтировать вручную, для теста: 
```
sudo mount /dev/sdb1 /mnt/backup_disk
df -h | grep backup_disk
```
#### Шаг 1.2 - автоматическое монтирование
Узнаём UUID диска:
```
sudo blkid /dev/sdb1
```
Запоминаем UUID, например: UUID="a1b2c3d4-e5f6-7890-g1h2-i3j4k5l6m7n8" <br>
Добавляем запись в конец dstab:
```
sudo nano /etc/fstab
UUID=a1b2c3d4-e5f6-7890-g1h2-i3j4k5l6m7n8   /mnt/backup_disk   ext4   defaults   0 2
```
Сохраняемся. Диск уже должен монитроваться, в случае перезапуска. <br>
Проверить, без перезаупска можно отмонтировав диск и перезапустив демонов.
```
sudo umount /mnt/backup_disk
sudo mount -a

```
Проверка, что диск примонтировался:
```
df -h | grep backup_disk
```
