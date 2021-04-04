#! /usr/bin/env bash


pg_create_tables='create table Costs (id SERIAL NOT NULL primary key, name varchar(255), price DECIMAL(10,2)); create table Products (id SERIAL not  null primary key, name varchar(255) not null, status varchar(50), quantity int, priceId int, foreign key (priceId) references Costs(id) on delete cascade);'
file_products=products.txt
declare -a products
products=(`cat "$file_products"`)

function save_data(){
docker exec -it postgres pg_dump -Fp -U postgres -d testpq  -f /tmp/buckup.sql
}

function create_tables() {
docker exec -it postgres  psql -U postgres -d testpq  -c "$pg_create_tables" 
}
function insert_to_table(){
	echo "Введите нужное количество товаров"
	read number
	for (( i = 0; i <= $number; i++)) 
		do
			r=$(( RANDOM % 20 ))
			n=${products[$r]}
			docker exec -it postgres psql -U postgres -d testpq -c "INSERT INTO Costs (name, price) SELECT '$n', random() * 100"
			c=`docker exec -ti postgres psql -t -U postgres -d testpq -c "SELECT MAX(id) FROM Costs"`
			docker exec -it postgres psql -U postgres -d testpq -c "INSERT INTO Products (name, status, quantity, priceId) SELECT '$n', 'Available', round(random() * 100), $c "
		done
}


echo "Cоздать таблицы в БД нажмите 1"
echo "Cохранить данные из БД postgres нажмите 2"
echo "Выйти ctrl-C"
read var
case $var in
	1 )  create_tables;;
	2 )  save_data;;
	3 )  insert_to_table;;
	* )  echo "Неверный ввод";;
esac	

