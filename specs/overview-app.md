Especificación de Proyecto: App de Finanzas Personales
1. Resumen del Proyecto
Se trata de una aplicación móvil para iOS y Android de seguimiento de finanzas personales. El objetivo es permitir al usuario registrar sus ingresos y gastos de forma manual, categorizarlos y visualizar un balance total, así como resúmenes de su actividad financiera por periodos de tiempo. La aplicación será desarrollada en Flutter utilizando una Clean Architecture con principios de Domain-Driven Design (DDD) para asegurar un código limpio, escalable y mantenible.

2. Funcionalidades Clave
Registro de Transacciones: El usuario puede añadir nuevas transacciones, especificando si es un ingreso o un gasto.

Gestión de Categorías (CRUD): El usuario puede crear, ver, editar y eliminar sus propias categorías para organizar las transacciones, todo esto se verá reflejado en la base de datos local isar, todos los nuevos incomes, expenses, y la lista de transacciones realizadas reposaran en isar.

Dashboard Principal (Overview):

Muestra el Balance Total (la suma histórica de todos los ingresos menos todos los gastos).

Presenta tarjetas de resumen para Ingresos y Gastos totales dentro de un periodo de tiempo seleccionado.

Muestra una lista de las transacciones recientes.

Filtrado de Transacciones: En el dashboard, el usuario puede filtrar las tarjetas de resumen y la lista de transacciones por:

Semana (últimos 7 días).

Mes (mes actual).

Custom (un rango de fechas seleccionado por el usuario mediante un DatePicker).

Detalle y Edición: El usuario puede ver los detalles de una transacción existente y tiene la opción de editarla o eliminarla.

3. Arquitectura y Estructura del Proyecto
La aplicación seguirá una Clean Architecture estricta, dividida en las siguientes capas dentro del directorio lib/:

domain: Contiene la lógica de negocio pura, entidades y las interfaces de los repositorios. Es el núcleo de la app.

infrastructure: Implementa las interfaces del dominio. Contiene el código que interactúa con servicios externos como la base de datos (Isar).

presentation: La capa de UI (Widgets, Pantallas) y la gestión de estado de la UI (Provider).

config: Una capa transversal para la configuración de la app: enrutamiento, tema visual e inyección de dependencias (Service Locator).

4. Modelo de Dominio y Lógica de Negocio
Entidades Principales:

Transaction:

id (int): Identificador único.

name (String): Nombre o título de la transacción (ej: "Supermercado").

description (String, opcional): Detalles adicionales.

amount (double): El valor monetario, siempre positivo.

type (Enum TransactionType): income o expense.

date (DateTime): Fecha y hora en que se realizó la transacción.

category (Entity Category): La categoría asociada.

Category:

id (int): Identificador único.

name (String): Nombre de la categoría (ej: "Comida", "Salario").

iconCodePoint (int): El codePoint de un IconData (ej: Icons.shopping_cart.codePoint) para su representación visual.

colorValue (int): El valor entero ARGB de un color para la categoría.

Reglas de Negocio Clave:

El Balance Total se calcula como: SUMA(montos de todas las transacciones de tipo INGRESO) - SUMA(montos de todas las transacciones de tipo GASTO). Este cálculo es histórico y no se ve afectado por los filtros de fecha.

Los resúmenes de Ingresos y Gastos en el dashboard SÍ cambian según el filtro de fecha seleccionado (Semana, Mes, Custom).

Toda transacción debe estar asociada obligatoriamente a una categoría.

Los montos de las transacciones siempre se registran como valores positivos. El type determina su efecto en el balance.

5. Especificaciones Técnicas (Stack Tecnológico)
Framework: Flutter (compilar para Android e iOS).

Gestor de Estado: provider.

Base de Datos Local: isar y isar_flutter_libs (con isar_generator y build_runner para la generación de código).

Enrutamiento (Routing): go_router.

Inyección de Dependencias: get_it (para implementar el patrón Service Locator).

Tipografía: google_fonts.

6. Diseño y UI/UX
Framework de Diseño: Material Design 3. La app debe inicializarse con ThemeData(useMaterial3: true).

Tema: Predominantemente un tema claro (ColorScheme.light()), con un color de acento principal azul para botones, íconos activos y elementos isnteractivos (Floating Action Button, etc.), tal como se ve en los mockups.

Tipografía: La fuente principal para toda la aplicación será Montserrat, importada a través del paquete google_fonts y configurada en el AppTheme (textTheme: GoogleFonts.latoTextTheme()).

Pantallas (Pages):

Overview Screen (/): La pantalla principal. Contiene un AppBar, el Balance Total, las tarjetas de resumen, los botones de filtro y la lista de transacciones. Incluye un FloatingActionButton (+) para añadir una nueva transacción.

En la parte superior izquierda de la Overview Screen (/) debe existir un icono que permita alternar entre modo claro y oscuro. 

Transaction Form Screen (/add-transaction, /edit-transaction/:id): Un formulario para crear o editar una transacción. Incluye un ToggleButton para Expense/Income, campos de texto para nombre y descripción, un DropdownButton para seleccionar la Category, un DatePicker para la fecha y un campo para el Amount.

Transaction Detail Screen (/transaction/:id): Muestra la información de una transacción en modo lectura. Contiene botones para "Editar" y "Eliminar".

Category Management Screen (/categories): Permite al usuario gestionar sus categorías. Muestra una lista de las categorías existentes con un ícono para editarlas. En la parte superior, tiene un campo de texto y un botón para crear una nueva categoría.

7. Funcionalidades Fuera de Alcance (Versión Inicial)
Para mantener el enfoque, las siguientes funcionalidades NO se incluirán en la primera versión:

Transacciones recurrentes o automáticas.

Soporte para múltiples cuentas o billeteras.

Sincronización en la nube o backup de datos.

Soporte para múltiples monedas.