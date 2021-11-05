import misiones.*
/** First Wollok example */

// PUNTOS DE ENTRADA DE LOS REQUERIMIENTOS

//1) empleado.estaIncapacitado() -> BOOL
//2) empleado.puedeUsarHabilidad(habilidad) -> BOOL
//3) empleado.cumplir(mision) [accion]
//	 equipo.cimplir(mison)	[accion]


//2) chat.recibir(mensaje)	[Acción]
//3) usuario.buscarTexto(texto) -> Chats
//4) usuario.mensajesMasPesados() -> Mensajes
//5) a) Se resuelve en Chat.recibir [acción]
//	 b) usuario.leer(chat) [acción]
//	 c) usuario.notificacionesSinLeer() -> Notificaciones

object wollok {
	method howAreYou() = 'I am Wolloktastic!'
}
class Empleado{
	var property tipoEmpleado = oficinista		// oficinista o espia 
	var habilidades = #{}
	var property salud
	var property equipo 
		
	method estaIncapacitado() = salud < tipoEmpleado.saludCritica()		//  1
	method estaVivo() = salud > 0  
	
	method aprenderHabilidad(hab){ habilidades.add(hab)}
	method puedeUsarHabilidad(hab) = self.estaIncapacitado().negate() && self.tieneHabilidad(hab)  // 2
	method tieneHabilidad(hab) = habilidades.constains(hab)
	
	method unirseEquipo(team){ 
		self.equipo(team)
		equipo.reclutar(self)
	} 
	
	method cumplir(mision){				//3
		if( self.puedeCumplir(mision)){
			self.recibirDanio(mision.peligrosidad()) // Cuand ohay tanto self MMMM code smeellll diuuu. En este caso la responsabilidad era de la mision
		}else{
			self.error("el emplado no Puede cumplir la mision porque no reube con todas las habilidades requeridas")
		}
	}
	
	method puedeCumplir(mision) = mision.habilidadesRequeridas().all{hab => self.puedeUsarHabilidad(hab)}	
	
	method recibirDanio(mision){
		salud -= mision.peligrosidad()
		if (self.estaVivo()){
			tipoEmpleado.completarMision(mision, self)
		}
	}
	
}

object espia{
	const property saludCritica = 15

	method completarMision(mision, empleado){
		empleado.aprenderHabilidad()			//  se podria delegar a la mision oara no mandar mensaje del objeto usado al jefe q lo usa para componer
	} 					
	
}
object oficinista{
	var property estrellas = 0
	
	method saludCritica() = 40 - (5 * self.estrellas())
	method ganarEstrella(empleado){
		estrellas += 1
		if (estrellas == 3){
			empleado.tipoEmpleado(espia)
		}
	}
	
	method completarMision(_, empleado){self.ganarEstrella(empleado) }

}

class Jefe inherits Empleado {
	var property subordinados = #{}	//empleados
	
	override method tieneHabilidad(hab) = super(hab) || self.algunSubPuedenUsar(hab)
	
	method algunSubPuedenUsar(hab) = subordinados.any({ emp => emp.puedeUsarHabilildad(hab) })
}