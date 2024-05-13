*
 * 
 * View importe venddido por los empleados*/

create view ImporteVendidoEmpleado as 
select year(p.fecha_pedido), e.Nombre , e.Apellidos,round(sum(p.Importe),2)
from empleados e inner join pedido p 
					on e.cod_empleado = p.Empleados_cod_empleado
group by year(p.fecha_pedido),e.cod_empleado
order by 1 asc, 4 desc;


/*  view productos vendidos por zonas el año anterior*/

create view productosPorZonasUltimoAño as select c.Sector , p2.nombre, count(p2.nombre)
	from clientes c  inner join pedido p 
			on c.cod_cliente = p.Clientes_cod_cliente 
					inner join `detalle pedido` dp 
			on p.cod_pedido  = dp.Pedido_cod_pedido
					inner join producto p2 
			on dp.Producto_cod_producto = p2.cod_producto
	where year(p.Fecha_pedido) = year(current_date())-1
	group by c.Sector, p2.nombre 
	order by c.Sector asc;
	

/*PROCEDIMIENTOS*/

/* Procedimiento para actualizar precios*/

delimiter $$
create procedure actualizar_precios (in porcentaje decimal (4,2), nombreFamilia varchar(45))

begin
	
	update producto set precio_venta = precio_venta*(1+ (porcentaje/100)) where cod_familia in (select cod_familia from familia where nombre like nombreFamilia);
	
end $$

delimiter ;


/*   procedimiento para calcular  detalle comision/cliente /empleado / año utiliza funcion */

delimiter $$

create procedure comision_anual_por_cliente (idEmpleado int , anio int)

begin
	
select p.Clientes_cod_cliente, sum(p.Importe), calculocomision(p.Empleados_cod_empleado, p.Clientes_cod_cliente, anio )
from pedido p  inner join empleados e  
			on p.Empleados_cod_empleado = e.cod_empleado 
where p.Empleados_cod_empleado like idEmpleado and year(p.Fecha_pedido) like anio
group by p.Clientes_cod_cliente , p.Empleados_cod_empleado;
	
end $$

delimiter ;


/*Procedimiento que reciba un código de pedido y muestre el detalle 
 * de dicho pedido (con los nombres de los productos, 
 * precio y la cantidad, y subtotal).
 * 
 * 
 */
delimiter $$

create procedure detallePedido( cod_pedido int)

begin
	select  p.nombre, dp.cantidad ,dp.precio, dp.cantidad*dp.precio  as subtotal
	from `detalle pedido` dp  inner join producto p 
				on dp.Producto_cod_producto = p.cod_producto
	where dp.Pedido_cod_pedido= cod_pedido;
end$$

delimiter ;


/* Procedimiento con cursor */


drop procedure if exists informe_anual;
delimiter $$
create procedure informe_anual()

begin
	declare salida varchar(2000) default 'Ventas totales: \t' ;
											
											
	declare suma_total decimal (10,2) default 0;
	declare anio year;
	declare done boolean default false;
	-- cursro de años
	declare c1 cursor for 	select  year(p.Fecha_pedido), sum(p.Importe)
							from pedido p  
							group by year(p.Fecha_pedido)  
							order by 1 asc;
		-- para salir del bucle
	declare continue handler for not found set done = true;

 -- datos anteriores
			select  sum(p.Importe) into suma_total
			from pedido p  ;

			set salida = concat(salida,' ', suma_total,'€\n');

		-- abrir el cursor
	open c1;
	-- recorrer el cursor
	
		while(not done) do
		
			fetch c1 into anio, suma_total;
		if (not done) then
			set salida = concat(salida,'En ', anio,': \t\t',suma_total,'€\n');
		end if;
		end while;
	-- cierro el cursor
	close c1;

	
	

select salida;
end $$

delimiter ;

call informe_anual();


/* Procedimiento2 con cursor */


drop procedure if exists informe_anual2;
delimiter $$
create procedure informe_anual2()

begin
	declare salida varchar(3000) default 'Ventas totales (anuales): \t' ;
											
											
	declare suma_total decimal (10,2) default 0;
	declare suma_mes decimal (10,2) default 0;
	declare anio year;
	declare anio2 year;
	declare mesN int;
	declare mes varchar(10);
	declare done boolean default false;
	
	-- cursro de años
	declare c1 cursor for 	select  year(p.Fecha_pedido), sum(p.Importe)
							from pedido p  
							group by year(p.Fecha_pedido)  
							order by 1 asc;

						
	declare c2 cursor for select  year(p.Fecha_pedido),month(p.Fecha_pedido),monthname(p.Fecha_pedido), sum(p.Importe)
							from pedido p
							group by year(p.Fecha_pedido),month(p.Fecha_pedido),monthname(p.Fecha_pedido)  
							; 					
		-- para salir del bucle
	declare continue handler for not found set done = true;

	
 -- datos anteriores
			select  round(sum(p.Importe),2) into suma_total
			from pedido p  ;

			set salida = concat(salida,' ', suma_total,'€\n');

		-- abrir el cursor
	open c1;
	-- recorrer el cursor
	
		while(not done) do
		
			fetch c1 into anio, suma_total;
		
		    if (not done) then
			    set salida = concat(salida,'\nEn ', anio,': \t\t',suma_total,'€\n\n');
	            open c2;
		
				while(not done) do
		
					fetch c2 into anio2,mesN, mes, suma_mes;
						if (not done) and (anio = anio2) then
						set salida = concat(salida, mesN,' - ',mes,': \t\t',suma_mes,'€\n');
						end if;
				end while;
				close c2;
			set done = false;
		end if;
		end while;
	-- cierro el cursor
	close c1;
set done = false;
	/*-- open c2;
		
		--		while(not done) do
		
					fetch c2 into mesN, mes, suma_mes;
						if (not done) then
						set salida = concat(salida, mesN,' - ',mes,': \t\t',suma_mes,'€\n');
						end if;
				end while;
				close c2;*/
			
		


select salida;
end $$

delimiter ;


/*FUNCIONES*/

/* funcion calculo de comision cliente/empleado por año*/
delimiter $$

create function calculocomision (idEmpleado int, cod_cliente int, anio int) returns decimal(10,2)
deterministic
begin
	
	declare total_vendido decimal(10,2) default 0;
	declare porcentaje decimal(10,2) default 0;
	select sum(p.Importe) into total_vendido
	from pedido p  inner join empleados e  
			on p.Empleados_cod_empleado = e.cod_empleado 
where p.Empleados_cod_empleado like idEmpleado and year(p.Fecha_pedido) like anio  and p.Clientes_cod_cliente like cod_cliente
group by p.Clientes_cod_cliente , p.Empleados_cod_empleado; 

select enc.porcentaje_comision into porcentaje  
from empleados_negocia_clientes enc 
where enc.Empleados_cod_empleado like idEmpleado and enc.Clientes_cod_cliente like cod_cliente;



return total_vendido * porcentaje /100;

end $$

delimiter ;

/*DEVUELVE EL IMPORTE GASTADO POR CLIENTE Y AÑO*/

CREATE FUNCTION importe_cliente_anio(id_cliente int, anio year) RETURNS varchar(100) 
    DETERMINISTIC
begin
	declare resultado decimal (10,2) default 0;
	declare salida varchar(100);
set resultado=(
		select sum(p.Importe)
			from pedido p 
			where p.Clientes_cod_cliente =id_cliente and year(p.fecha_pedido) like anio);
if (resultado is null) then
	set salida = concat ('El cliente ',id_cliente,' no existe');
else
	set salida = concat('El cliente ',id_cliente,' ha consumido ',resultado, ' € en ', anio);
end if;
return salida;
	
end;

/*TRIGGERS*/

/*Trigger de crear historico de precios*/

create table historico_precios(
	cod_producto int,
	nombre varchar(200),
	precio_compra double,
	precio_venta double,
	fecha_modificacion date,
	primary key (cod_producto, fecha_modificacion),
	foreign key (cod_producto) references producto(cod_producto)
	on delete restrict
);

delimiter $$

create trigger guardarPrecios

after update on producto for each row 

begin
	if (old.precio_compra<>new.precio_compra) then
	insert into historico_precios values (old.cod_producto, old.nombre, old.precio_compra, old.precio_venta, current_date());
	else if (old.precio_venta <> new.precio_venta) then
	insert into historico_precios values (old.cod_producto, old.nombre, old.precio_compra, old.precio_venta, current_date());
	end if;
	end if;

end $$

delimiter ;

/* Trigger 2 crear historico de cambiosnegociaciones*/

create table historico_negociaciones(
	Empleados_cod_empleado int,
	Clientes_cod_cliente int,
	tipo_comision varchar(45),
	porcentaje_comision decimal(10,0),
	fecha_cambio date,
	primary key (Empleados_cod_empleado, Clientes_cod_cliente, fecha_cambio)
	
	
);
delimiter $$

create trigger historicoNegociaciones

after update on empleados_negocia_clientes for each row 

begin
	if (old.tipo_comision<>new.tipo_comision) then
	insert into historico_negociaciones values (old.Empleados_cod_empleado, old.Clientes_cod_cliente, old.tipo_comision, old.porcentaje_comision, current_date());
	else if (old.porcentaje_comision <> new.porcentaje_comision) then
	insert into historico_negociaciones values (old.Empleados_cod_empleado, old.Clientes_cod_cliente, old.tipo_comision, old.porcentaje_comision, current_date());
	else if (old.Empleados_cod_empleado<>new.Empleados_cod_empleado) then
	insert into historico_negociaciones values (old.Empleados_cod_empleado, old.Clientes_cod_cliente, old.tipo_comision, old.porcentaje_comision, current_date());
	end if;
	end if;
	end if;

end $$

delimiter ;