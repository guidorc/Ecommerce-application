import React from "react";

function Producto(item) {
  return (
    <div className="col-lg-4">
      <div className="card m-2">
        <div className="card-body">
          <div className="text-muted">#{item.id}</div>
          <h5 className="pt-5 border-top">{item.title}</h5>
          <div>${item.total}</div>
        </div>
        <div className="card-footer">
          <div className="float-left">
            <span className="badge">{item.cantidad}</span>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Producto;
