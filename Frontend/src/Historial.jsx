import React, { Component } from "react";
import user_info from "./user_info";
import Producto from "./ProductoEnHistorial";

class Historial extends Component {
  constructor(props) {
    // llamar al constructor de la superclase
    super(props);
    // Inicializar el estado
    this.state = {
      items: [],
    };
  }

  render() {
    return (
      <div>
        <h4>Historial de Compras</h4>
        <div>
          {this.state.items.map((item) => (
            <Producto key={item.id} item={item} />
          ))}
        </div>
      </div>
    );
  }

  componentDidMount = async () => {
    /* Obtener el Catálogo de Libros */
    var response = await fetch(
      `http://localhost:8080/listPurchases?clientId=${user_info.username}&password=${user_info.password}`,
      {
        method: "GET",
      }
    );

    /* Actualizar la lista de productos */
    var historial = await response.json();
    console.log(historial);
    this.setState({ items: historial });
  };
}

export default Historial;
