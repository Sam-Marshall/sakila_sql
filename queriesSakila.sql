use sakila;

set SQL_SAFE_UPDATES =  0;

select first_name, last_name 
	from actor; #1a
    
select upper(concat(first_name, ' ', last_name)) as FullName 
	from actor; #1b
    
select * 
	from actor 
    where first_name = 'Joe'; #2a
    
select * 
	from actor 
    where last_name like '%GEN%'; #2b
    
select * 
	from actor 
    where last_name like '%LI%' 
    order by last_name, first_name; #2c
    
select country_id, country 
	from country 
    where country in ('Afghanistan', 'Bangladesh','China'); #2d
    
alter table actor 
	add middle_name varchar(50); #3a
    
alter table actor 
	modify middle_name blob; #3b
    
alter table actor 
	drop column middle_name; #3c
    
select last_name, count(last_name) as 'Number_of_Actors' 
	from actor 
    group by last_name; #4a
    
select last_name, count(last_name) as 'Number_of_Actors' 
	from actor 
    group by last_name 
    having count(last_name) > 1; #4b
    
update actor 
	set first_name = 'HARPO' 
    where first_name= 'GROUCHO' and last_name='WILLIAMS'; #4c
    
update actor 
	set first_name = case 
			when first_name='GROUCHO'  then  'MUCHO GROUCHO' 
			when first_name='HARPO'  then 'GROUCHO' 
			else first_name 
	end ; #4d
    
show create table address; #5a

select staff.first_name, staff.last_name, address.address 
	from staff 
    inner join address on staff.address_id=address.address_id; #6a
    
select staff.first_name, staff.last_name, sum(payment.amount) as 'Total Sum'
	from staff 
    inner join payment on staff.staff_id=payment.staff_id 
    group by staff.staff_id; #6b
    
select film.title, count(film_actor.film_id) as 'Num Actors'
	from film
    inner join film_actor on film.film_id=film_actor.film_id
    group by film.title; #6c
    
select film.title, count(inventory.film_id) as 'Num Copies'
	from film
    inner join inventory on film.film_id=inventory.film_id 
    where film.title='Hunchback Impossible'
    group by film.title; #6d

select customer.first_name, customer.last_name, sum(payment.amount) as 'Amt Paid'
	from customer
    inner join payment on customer.customer_id=payment.customer_id 
	group by customer.customer_id
    order by customer.last_name; #6e
    
select film.title, language.name
	from film
    inner join language on film.language_id = language.language_id
    where language.name = 'English' and (film.title like 'k%' or film.title like 'q%'); #7a
    
select actor.first_name, actor.last_name, film.title 
	from actor
    inner join film_actor on actor.actor_id=film_actor.actor_id
    inner join film on film.film_id=film_actor.film_id
    where film.title = 'Alone Trip'; #7b
    
select customer.first_name, customer.last_name, customer.email, country.country
	from address
    inner join city on address.city_id=city.city_id
    inner join country on city.country_id=country.country_id
    inner join customer on customer.address_id=address.address_id
    where country.country = 'Canada'; #7c

select film.title, category.name
	from category
    inner join film_category on category.category_id=film_category.category_id
    inner join film on film.film_id=film_category.film_id
    where category.name = 'Family'; #7d

select film.title, count(film.title) as 'Times Rented'
	from inventory
    inner join rental on inventory.inventory_id = rental.inventory_id
    inner join film on inventory.film_id=film.film_id
    group by film.title
    order by count(film.title) desc; #7e
    
select store.store_id, sum(payment.amount) as 'Store Revenue'
	from rental
    inner join inventory on rental.inventory_id=inventory.inventory_id
    inner join payment on rental.rental_id=payment.rental_id
    inner join store on inventory.store_id=store.store_id
    group by store.store_id 
    order by sum(payment.amount) desc; #7f

select store.store_id, city.city, country.country
	from city 
    inner join country on city.country_id=country.country_id
    inner join address on city.city_id=address.city_id
    inner join store on address.address_id=store.address_id; #7g

select category.name, sum(payment.amount) as 'Gross Revenue'
	from category
    inner join film_category on category.category_id=film_category.category_id
    inner join film on film_category.film_id=film.film_id
    inner join inventory on film.film_id=inventory.film_id
    inner join rental on inventory.inventory_id=rental.inventory_id
    inner join payment on rental.rental_id=payment.rental_id
    group by category.name
    order by sum(payment.amount) desc
    limit 5; #7h

create view Top_5_Grossing_Films as
	(select category.name, sum(payment.amount) as 'Gross Revenue'
		from category
		inner join film_category on category.category_id=film_category.category_id
		inner join film on film_category.film_id=film.film_id
		inner join inventory on film.film_id=inventory.film_id
		inner join rental on inventory.inventory_id=rental.inventory_id
		inner join payment on rental.rental_id=payment.rental_id
		group by category.name
		order by sum(payment.amount) desc
		limit 5);  #8a
        
select * from Top_5_Grossing_Films; #8b

drop view Top_5_Grossing_Films; #8c