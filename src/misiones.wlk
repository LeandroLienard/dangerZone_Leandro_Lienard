import example.*

class Mision{
	var property peligrosidad = 10		// peligrosidad == danioTotal ?? 
	var property habilidadesRequeridas = #{}
}

class Equipo{
	var integrantes = #{}
	
	method reclutar(emp){	integrantes.add(emp)	}
	
	
	method cumplirMision(mision){							//3
		if ( self.algunIntegrantePuedeCumplir(mision)) {
			integrantes.forEach({unIntegrante => unIntegrante.recibirDanio(mision)})
		}
	}
	
	method algunIntegrantePuedeCumplir(mision) = integrantes.any{unIntegrante => unIntegrante.puedeCumplir(mision)}
}
