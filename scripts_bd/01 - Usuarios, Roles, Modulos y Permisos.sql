-- Tabla de usuarios
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  activo BOOLEAN DEFAULT TRUE,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de roles
CREATE TABLE roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) UNIQUE NOT NULL,
  descripcion VARCHAR(255),
  activo BOOLEAN DEFAULT TRUE
);

-- Tabla intermedia: usuarios_roles (relación N a N)
CREATE TABLE usuarios_roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  rol_id INT NOT NULL,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE,
  UNIQUE (usuario_id, rol_id)
);

-- Tabla de módulos del sistema
CREATE TABLE modulos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) UNIQUE NOT NULL,  -- clave interna, ej: 'cotizaciones'
  descripcion VARCHAR(255),
  activo BOOLEAN DEFAULT TRUE
);

-- Tabla de permisos por rol y módulo
CREATE TABLE permisos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rol_id INT NOT NULL,
  modulo_id INT NOT NULL,
  puede_ver BOOLEAN DEFAULT FALSE,
  puede_crear BOOLEAN DEFAULT FALSE,
  puede_editar BOOLEAN DEFAULT FALSE,
  puede_eliminar BOOLEAN DEFAULT FALSE,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (modulo_id) REFERENCES modulos(id) ON DELETE CASCADE,
  UNIQUE (rol_id, modulo_id)
);

-- Tabla de sesiones activas
CREATE TABLE sesiones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  token VARCHAR(255) UNIQUE NOT NULL,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  expiracion DATETIME,
  activo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Rol administrador
INSERT INTO roles (nombre, descripcion) VALUES
('admin', 'Administrador del sistema');

-- Usuario administrador
INSERT INTO usuarios (username, nombre, email, password_hash) VALUES
('metaltux', 'Juan Ríos', 'jrios.03@hotmail.com', '$2y$10$HASHDEEJEMPLO1234567890abcdefg'); 
-- Reemplaza el hash con uno real, por ejemplo con bcrypt

-- Relación usuario/rol
INSERT INTO usuarios_roles (usuario_id, rol_id)
SELECT u.id, r.id FROM usuarios u, roles r
WHERE u.username = 'metaltux' AND r.nombre = 'admin';

-- Módulos del sistema
INSERT INTO modulos (nombre, descripcion) VALUES
('cotizaciones', 'Gestión de cotizaciones'),
('ordenes_compra', 'Gestión de órdenes de compra'),
('ordenes_trabajo', 'Gestión de órdenes de trabajo'),
('entregas', 'Registro de entregas de proyecto'),
('pagos', 'Gestión de pagos');

-- Permisos para el rol admin (todos los permisos en todos los módulos)
INSERT INTO permisos (rol_id, modulo_id, puede_ver, puede_crear, puede_editar, puede_eliminar)
SELECT
  r.id, m.id, TRUE, TRUE, TRUE, TRUE
FROM roles r
JOIN modulos m ON 1=1
WHERE r.nombre = 'admin';