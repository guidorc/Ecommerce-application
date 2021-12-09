import React, { Component } from "react";
import Producto from "./ProductoEnCatálogo";
import cartId from "./cartId";

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
                <button
                  className="btn btn-primary"
                  /* Paso el parámetro así por ser un evento */
                  onClick={() => this.onAddClick(prod)}
                >
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
      method: "GET",
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

  onAddClick = async (producto) => {
    /* Agregar el producto al carrito del usuario */
    var response = await fetch(
      `http://localhost:8080/addToCart?cartId=${cartId.id}&bookIsbn=${producto.titulo}&bookQuantity=${producto.cantidad}`,
      { method: "GET" }
    );

    if (response.ok) {
      window.alert("El elemento fué agregado con éxito!");
    } else {
      window.alert("El elemento no pudo agregarse al carrito.");
    }
  };
}

export default Catalogo;
