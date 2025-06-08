extends Node
class_name ItemFuncionality

static var habilidades_activas := {
	"inicio_primigeneo": func (objetivo): objetivo.recibir_dano(20, "fuego")
}
