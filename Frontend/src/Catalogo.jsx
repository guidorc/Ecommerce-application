import React, { Component } from "react";
import Producto from "./ProductoEnCatálogo";
import CarritoDeCompras from "./Carrito";
import { handleIncrement } from "./Carrito";

class Catalogo extends Component {
  constructor(props) {
    // llamar al constructor de la superclase
    super(props);
    // Inicializar el estado
    this.state = {
      productos: [],
    };
  }

  render() {
    return (
      <div>
        <h4>Catálogo</h4>
        <div className="row">
          {this.state.productos.map((prod) => {
            return (
              <Producto
                key={prod.id}
                producto={prod}
                onIncrement={this.handleIncrement}
                onDecrement={this.handleDecrement}
              >
                <button className="btn btn-primary" onClick={this.onAddClick}>
                  Añadir
                </button>
              </Producto>
            );
          })}
        </div>
      </div>
    );
  }

  componentDidMount = async () => {
    /* Obtener el Catálogo de Libros */
    var response = await fetch("http://localhost:8080/catalog", {
      methog: "GET",
    });

    /* Actualizar la lista de productos */
    var catalogo = await response.json();
    this.setState({ productos: catalogo });
  };

  handleIncrement = (producto) => {
    let nuevosProductos = [...this.state.productos];
    let indice = nuevosProductos.indexOf(producto);
    nuevosProductos[indice].cantidad++;
    this.setState({ productos: nuevosProductos });
  };

  handleDecrement = (producto) => {
    let nuevosProductos = [...this.state.productos];
    let indice = nuevosProductos.indexOf(producto);
    let cantidadActual = nuevosProductos[indice].cantidad;
    cantidadActual--;
    nuevosProductos[indice].cantidad = Math.max(0, cantidadActual);
    this.setState({ productos: nuevosProductos });
  };

  onAddClick = (producto) => {
    CarritoDeCompras.addProduct(producto);
  };
}

export default Catalogo;
