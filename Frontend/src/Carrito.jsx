import React, { Component } from "react";
import Producto from "./ProductoEnCarrito";

class CarritoDeCompras extends Component {
  constructor(props) {
    // llamar al constructor de la superclase
    super(props);
    // Inicializar el estado
    this.state = {
      productos: [],
      cartId: null,
    };
  }

  render() {
    return (
      <div>
        <h4>Carrito</h4>
        <div className="row">
          {this.state.productos.map((prod) => {
            return (
              <Producto
                key={prod.id}
                producto={prod}
                onIncrement={this.handleIncrement}
                onDecrement={this.handleDecrement}
                onDelete={this.handleDelete}
              ></Producto>
            );
          })}
        </div>
        <button className="btn btn-primary" onClick={this.onBuyClick}>
          Comprar
        </button>
      </div>
    );
  }

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

  handleDelete = (producto) => {
    let nuevosProductos = [...this.state.productos];
    let indice = nuevosProductos.indexOf(producto);

    if (
      window.confirm("Está seguro que desea quitar el elemento del carrito?")
    ) {
      nuevosProductos.splice(indice, 1);
      this.setState({ productos: nuevosProductos });
    }
  };

  onBuyClick = (producto) => {};

  addProduct = (producto) => {};
}

export default CarritoDeCompras;
//export function addProduct(p);
