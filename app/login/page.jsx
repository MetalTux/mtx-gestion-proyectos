'use client';

import { useState } from 'react';

export default function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [mensaje, setMensaje] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();

    const res = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    });

    const data = await res.json();
    if (res.ok) {
      setMensaje('Inicio de sesión exitoso');
      // Aquí puedes redirigir, guardar el token, etc.
    } else {
      setMensaje(data.message || 'Error al iniciar sesión');
    }
  };

  return (
    <main className="form-signin w-100 m-auto text-center" style={{ maxWidth: '330px', padding: '15px' }}>
      <form onSubmit={handleSubmit}>
        <h1 className="h3 mb-3 fw-normal">Iniciar sesión</h1>

        <div className="form-floating">
          <input
            type="text"
            className="form-control"
            id="floatingInput"
            placeholder="admin"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
          <label htmlFor="floatingInput">Usuario</label>
        </div>

        <div className="form-floating mt-2">
          <input
            type="password"
            className="form-control"
            id="floatingPassword"
            placeholder="Contraseña"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
          <label htmlFor="floatingPassword">Contraseña</label>
        </div>

        <button className="w-100 btn btn-lg btn-primary mt-3" type="submit">
          Ingresar
        </button>

        {mensaje && <div className="alert alert-info mt-3">{mensaje}</div>}
      </form>
    </main>
  );
}