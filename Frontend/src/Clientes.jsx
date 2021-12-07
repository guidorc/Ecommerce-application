import React, { Component } from "react";

class ListaDeClientes extends Component {
  state = {
    pageTitle: "Clientes:",
    customersCount: 5,
    clientes: [
      {
        id: 1,
        nombre: "Jorge Luis",
        numero_de_telefono: "1234-5678",
        direccion: { ciudad: "Buenos Aires" },
        foto: "https://picsum.photos/id/1010/60",
      },
      {
        id: 2,
        nombre: "Julio",
        numero_de_telefono: "1234-5678",
        direccion: { ciudad: "Paris" },
        foto: "https://picsum.photos/id/1011/60",
      },
      {
        id: 3,
        nombre: "Pablo",
        numero_de_telefono: "1234-5678",
        direccion: { ciudad: "Santiago" },
        foto: "https://picsum.photos/id/1012/60",
      },
      {
        id: 4,
        nombre: "Maria Elena",
        numero_de_telefono: null,
        direccion: { ciudad: "Buenos Aires" },
        foto: "https://picsum.photos/id/1013/60",
      },
      {
        id: 5,
        nombre: "Ernesto",
        numero_de_telefono: "1234-5678",
        direccion: { ciudad: "Buenos Aires" },
        foto: "https://picsum.photos/id/1014/60",
      },
    ],
  };

  render() {
    return (
      <div>
        <h4 className="m-1 p-1">
          {this.state.pageTitle}
          <span className="m-1 p-1">{this.state.customersCount}</span>
          <button className="btn btn-info" onClick={this.onRefreshClick}>
            Refresh
          </button>
        </h4>

        <table className="table">
          <thead>
            <tr>
              <th>#</th>
              <th>Foto</th>
              <th>Cliente</th>
              <th>Numero de Teléfono</th>
              <th>Ciudad</th>
            </tr>
          </thead>
          <tbody>{this.renderCustomerTable()}</tbody>
        </table>
      </div>
    );
  }

  // Se Ejecuta cuando el usuario cliquea en Refresh
  onRefreshClick = () => {
    this.setState({
      customersCount: 7,
    });
  };

  renderPhoneNumber(numero) {
    return numero ? (
      numero
    ) : (
      <div className="bg-warning p-2">No disponible</div>
    );
  }

  renderCustomerTable = () => {
    return this.state.clientes.map((cliente, indice) => {
      return (
        <tr key={cliente.id}>
          <td>{cliente.id}</td>
          <td>
            <img src={cliente.foto} alt="No Disponible" />
            <div>
              <button
                className="btn btn-sm btn-secondary"
                onClick={() => {
                  this.changePicture(cliente, indice);
                }}
              >
                Cambiar
              </button>
            </div>
          </td>
          <td>{cliente.nombre}</td>
          <td>{this.renderPhoneNumber(cliente.numero_de_telefono)}</td>
          <td>{cliente.direccion.ciudad}</td>
        </tr>
      );
    });
  };

  changePicture = (cliente, indice) => {
    var custArr = this.state.clientes;
    custArr[indice].foto = "https://picsum.photos/id/1014/60";
    this.setState({ clientes: custArr });
  };
}

export default ListaDeClientes;
