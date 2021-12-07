import React, { Component } from "react";

class Producto extends Component {
  constructor(props) {
    super(props);
    this.state = {
      producto: this.props.producto,
    };
  }

  render() {
    return (
      <div className="col-lg-4">
        <div className="card m-2">
          <div className="card-body">
            <div className="text-muted">
              #{this.state.producto.id}
              <span
                className="pull-right hand-icon"
                onClick={() => {
                  this.props.onDelete(this.state.producto);
                }}
              >
                <i className="fa fa-times"></i>
              </span>
            </div>

            <h5 className="pt-5 border-top">{this.state.producto.titulo}</h5>
            <div>${this.state.producto.precio}</div>
            <div>Autor: {this.state.producto.autor}</div>
          </div>

          <div className="card-footer">
            <div className="float-left">
              <span className="badge">{this.state.producto.cantidad}</span>
              <div className="btn-group">
                <button
                  className="btn btn-outline-success"
                  onClick={() => {
                    this.props.onIncrement(this.state.producto);
                  }}
                >
                  +
                </button>
                <button
                  className="btn btn-outline-success"
                  onClick={() => {
                    this.props.onDecrement(this.state.producto);
                  }}
                >
                  -
                </button>
              </div>
            </div>
            <div className="float-right">{this.props.children}</div>
          </div>
        </div>
      </div>
    );
  }
}

export default Producto;
