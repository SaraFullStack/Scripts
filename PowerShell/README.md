# SCRIPTS POWERSHELL
## procesos.ps1 🚀
Hacer un script que muestre un listado de cada uno de los procesos que pertenezcan al usuario que ha iniciado sesion y llevan mas de 1' en ejecucion.
Despues de mostrar el listado, mostrar este menu:

        1.aumentar su prioridad a High (comprobar que la ha cambiado, por defecto esta a NORMAL)
        2.matar el proceso.
        3---SALIR----

Se mandara un mensaje al log Applicaton de tipo Info indicando que:

	"se ha elevado la prioridad del proceso/finalizado el proceso con PID: CMD: .....a las ..... del dia ....."'
