import React from "react";

const Producto = ({ item }) => {
  return (
    <div className="col-lg-4">
      <div className="card m-2">
        <div className="card-body">
          <div className="text-muted">#{item.id}</div>
          <h5 className="pt-5 border-top">{item.title}</h5>
          {item.id !== "total" ? <div>Cantidad: {item.quantity}</div> : null}
          {item.id !== "total" ? (
            <div>Precio por unidad: ${item.total}</div>
          ) : (
            <div>${item.total}</div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Producto;
