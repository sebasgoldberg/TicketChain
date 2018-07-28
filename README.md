TICKETCHAIN
-----------

Objetivo
--------    

Disponibilizar un contrato que permita:
- Crear un evento.
- Asignar administradores del evento (opcional). Roles posibles:
    - Creador de tickets.
    - Vendedor de tickets.
- Determinar cuentas de ganacias, su porcentaje de distribución, y prioridad (opcional).
- Indicar distintas fechas del evento (de forma fija o recurrente).
- Indicar distintas ubicaciones por evento y su cantidad.
- Crear tickets para un evento optando por alguna de las siguientes opciones.
    - Mismo precio y sin numeración.
    - Distintos precios y sin numeración.
    - Numerada.
- Poner en venta tickets.
- Comprar tickets.
- Transferir tickets.
- Determinar el dueño de un ticket.
- Cancelar evento:
    - Se devuelve el valor de la entrada y se inhabilitan.
- Marcar un ticket como usado (solo el dueño y/o administrador(es) del evento).
- Compras grupales (varios tickets en la misma compra).
- Ventas grupales (se venden ciertos tickets si son comprados en conjunto).
- Restricciones de evento privado (solo ciertas cuentas pueden comprar).
- Limites de cantidad de tickets comprados por una misma cuenta.
- Inhabilitar el uso del contrato.
- Crear el Lugar del evento.

Cliente
-------

Tener un cliente que permita:
- Generar una prueba que soy dueño del ticket.
- Validar que una persona es dueña del ticket.
- Colocar un ticket en venta (solo el dueño del ticket).
- Comprar un ticket.
- Transferir un ticket (solo el dueño del ticket).
- Crear un evento.
- Crear tickets (solo el dueño del evento), de forma masiva.
- Marcar un ticket como usado (solo el dueño del evento).

La generación de la prueba y la validación, podría ser, suponiendo que cada ticket tiene un ID:
- El dueño encripta ese ID con su llave privada y pasa el mensaje encriptado junto con su llave publica.
- El validador desencripta el ID con la llave publica del dueño, y valida que el ID pertenece a esa llave publica.

Token Free
----------

En principio la solución funcionaria sin utilizar ningún tipo de token
con lo cual para los interesados no seria necesario especular ante un
pre sale, ni adquirir los token para realizar cualquier tipo de operación 
en la solución, ya sea administrador del evento o usuario de los tickets.

Tasa de Mantenimiento
---------------------

De forma de incentivar la creación de la solución, asi como su mantenimiento,
en cada operación de compra/venta de tickets sera cobrada una tasa fija de 
10 microether (10 szabo: 0,00001 Ether), que hoy, con el Ether a 450 dólares,
serían, aproximadamente 0,4 centavos de dólar.
Notar que otro tipo de operaciones no tienen costo alguno, excepto el gas
utilizado.
Notar que el precio es fijo, y no proporcional al valor del ticket, ya que
creo que vender un ticket de 100 dólares o uno de 5 dólares es igual de
importante.

Consideraciones
---------------

Todo debería empezar definiendo el lugar del evento, y su layout standard basado en sus
distintos sectores y ubicaciones por sector.
Debe ser definida la capacidad a nivel de sector o a nivel de ubicación.

Observación: Se hace la diferencia entre sector y ubicación de forma que se pueda
por ejemplo definir el precio a nivel de sector, pero la ubicación sea numerada.

El dueño del lugar podría colocar el lugar en alquiler de forma que para que alguien
pueda utilizarlo, tenga que:
- Abonar un monto fijo.
- Dar una participación de las entradas vendidas del evento.
Podria llegar a existir algún tipo de politica de cancelación.

El creador del evento tendría que:
- Crear el evento.
- Asignar las fechas del evento.
- Indicar los lugares donde sera llevado a cabo el evento.
- En caso de precisar, modificar el layout standard de cada lugar.
- Indicar los precios, con posibilidad de hacerlo a distintos niveles de detalle:
    - Evento
    - Lugar
    - Sector
    - Ubicación
    - Fecha/Evento
    - Fecha/Lugar
    - Fecha/Sector
    - Fecha/Ubicación


