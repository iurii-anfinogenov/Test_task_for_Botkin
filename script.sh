#! /usr/bin/env bash


my_create_tables='create table Costs (id INT NOT NULL primary key AUTO_INCREMENT, name varchar(255), price DECIMAL(10,2));CREATE TABLE Products (id SERIAL NOT NULL PRIMARY KEY, name VARCHAR(255), status VARCHAR(50), quantity INT, priceId INT , FOREIGN KEY (priceId) REFERENCES Costs(id) ON DELETE CASCADE)' 
pg_create_tables='create table Costs (id SERIAL NOT NULL primary key, name varchar(255), price DECIMAL(10,2)); create table Products (id SERIAL not  null primary key, name varchar(255) not null, status varchar(50), quantity int, priceId int, foreign key (priceId) references Costs(id) on delete cascade);'
file_products=products.txt
declare -a products
products=(`cat "$file_products"`)
sed -i.bak 's/\r$//' products.txt

function save_data(){
sudo docker exec -it postgres psql -U postgres -d testpq -t -A  -c "SELECT * FROM Products" > products_save.txt
sudo docker exec -it postgres psql -U postgres -d testpq -t -A  -c "SELECT * FROM Costs" > costs_save.txt
}


function create_tables() {
docker exec -it postgres  psql -U postgres -d testpq  -c "$pg_create_tables" 
docker exec -it mysql8 mysql -u root  testmy -e "$my_create_tables" 
}
function insert_to_table(){
#	echo "Введите нужное количество товаров"
#	read number
	for (( i = 0; i < 20; i++)) 
		do
			r=$(( RANDOM % 20 ))
			name=${products[$r]}
			docker exec -it postgres psql -U postgres -d testpq -c "INSERT INTO Costs (name, price) SELECT '$name', random() * 100"
			c=`docker exec -ti postgres psql -t -U postgres -d testpq -c "SELECT MAX(id) FROM Costs"`
			docker exec -it postgres psql -U postgres -d testpq -c "INSERT INTO Products (name, status, quantity, priceId) SELECT '$name', 'Available', round(random() * 100), $c" 
		done
}

function load_data_into_mysql(){
	file_costs=costs_save.txt
	file_product=products_save.txt

	declare -a costs
	declare -a product
	costs=(`cat "$file_costs"`)
	product=(`cat "$file_product"`)
	for (( i = 0; i < 20; i++ ))
		do 
			id=`echo ${costs[$i]} | cut -d '|' -f 1`
			name=`echo ${costs[$i]} | cut -d '|' -f 2`
			price=`echo ${costs[$i]} | cut -d '|' -f 3`
			echo $id - $name - $price
			docker exec -i mysql8 mysql -u root  testmy -e "INSERT INTO Costs (id, name, price) VALUES ($id, '$name', $price + 10)" 
		done
	for (( j = 0; j < 20; j++ ))
		do
			id=`echo ${product[$j]} | cut -d '|' -f 1`
			name=`echo ${product[$j]} | cut -d '|' -f 2`
			statusp=`echo ${product[$j]} | cut -d '|' -f 3`
			quantity=`echo ${product[$j]} | cut -d '|' -f 4`
			priceid=`echo ${product[$j]}  | cut -d '|' -f 5`		
			echo $id $name $statusp $quantity $priceid
			docker exec -i mysql8 mysql -u root  testmy -e "INSERT INTO Products (id, name, status, quantity, priceId) VALUES ($id, '$name', '$statusp', $quantity, $priceid)"
		done
		}		





#	while read LINE;
#		do    
#		id=`echo $LINE | cut -d '|' -f 1`
#		name=`echo $LINE | cut -d '|' -f 2`
#		price=`echo $LINE | cut -d '|' -f 3`
#		echo $id - $name - $price
#		docker exec -i mysql8 mysql -u root  testmy -e "INSERT INTO Costs (id, name, price) VALUES ($id, '$name', $price + 10)" 
#		
#
#	done 



echo "Cоздать таблицы в БД нажмите 1"
echo "Наполнить таблицы товарами нажмите 2"
echo "Выгрузить данные из БД postgres нажмите 3"
echo "Загрузить данные в MySQL с измененным прайсом нажмите 4"
echo "Выйти ctrl-C"
read var
case $var in
	1 )  create_tables;;
	2 )  insert_to_table;;
	3 )  save_data;;
	4 )  load_data_into_mysql;;
	* )  echo "Неверный ввод";;
esac	
