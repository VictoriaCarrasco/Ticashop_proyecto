-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-11-2025 a las 19:54:53
-- Versión del servidor: 12.0.2-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ticashop`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apptica_comisionventa`
--

CREATE TABLE `apptica_comisionventa` (
  `id` bigint(20) NOT NULL,
  `periodo` date NOT NULL,
  `ventas_totales` decimal(14,2) NOT NULL,
  `comision` decimal(14,2) DEFAULT NULL,
  `estado` varchar(20) NOT NULL,
  `empleado_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `apptica_comisionventa`
--

INSERT INTO `apptica_comisionventa` (`id`, `periodo`, `ventas_totales`, `comision`, `estado`, `empleado_id`) VALUES
(6, '2025-11-15', 70000.00, 1050.00, 'CALCULADA', 3),
(7, '2025-11-15', 9000.00, 135.00, 'CALCULADA', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apptica_empleado`
--

CREATE TABLE `apptica_empleado` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `email` varchar(254) NOT NULL,
  `rut` varchar(12) NOT NULL,
  `rol` varchar(20) NOT NULL,
  `departamento` varchar(20) NOT NULL,
  `activo` tinyint(1) NOT NULL,
  `saldo_vacaciones_dias` int(10) UNSIGNED NOT NULL CHECK (`saldo_vacaciones_dias` >= 0),
  `sueldo_fijo` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `apptica_empleado`
--

INSERT INTO `apptica_empleado` (`id`, `nombre`, `email`, `rut`, `rol`, `departamento`, `activo`, `saldo_vacaciones_dias`, `sueldo_fijo`) VALUES
(1, 'Victoria', 'victoriacarrascocc@gmail.com', '19647603-2', 'ADMIN', 'RRHH', 1, 15, 500000.00),
(2, 'Mariano', 'mariano@inacap.cl', '12345678-9', 'RRHH', 'RRHH', 1, 15, 500000.00),
(3, 'Felipe Silva', 'felipe@gmail.com', '2000000-0', 'TECNICO', 'OTRO', 1, 15, 500000.00),
(4, 'Matias Silva', 'mati@gmail.com', '11111111-1', 'SUP_COM', 'FINANZAS', 1, 15, 500000.00),
(10, 'Doki', 'doki@empresa.cl', '11111111-2', 'ADMIN', 'RRHH', 1, 15, 500000.00),
(11, 'Mr Emetea', 'mremetea@gmail.com', '1834615438-1', 'RRHH', 'RRHH', 1, 15, 500000.00),
(12, 'wwwww', 'awffaw@gmail.com', '12121212-5', 'GENERAL', 'VENTAS', 1, 15, 500000.00),
(13, 'Juanito Alvarez', 'Juan@gmail.com', '92648562-6', 'RRHH', 'RRHH', 1, 11, 900000.00),
(14, 'Batian Vargas', 'basti@gmail.com', '27451845-6', 'NOMINA', 'FINANZAS', 1, 0, 850000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apptica_liquidacion`
--

CREATE TABLE `apptica_liquidacion` (
  `id` bigint(20) NOT NULL,
  `periodo` date NOT NULL,
  `monto_total` decimal(14,2) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `pdf` varchar(100) DEFAULT NULL,
  `empleado_id` bigint(20) NOT NULL,
  `comisiones` decimal(14,2) DEFAULT NULL,
  `fecha_firma` datetime(6) DEFAULT NULL,
  `firma_empleado` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `apptica_liquidacion`
--

INSERT INTO `apptica_liquidacion` (`id`, `periodo`, `monto_total`, `estado`, `pdf`, `empleado_id`, `comisiones`, `fecha_firma`, `firma_empleado`) VALUES
(4, '2025-11-01', 450000.00, 'PENDIENTE_FIRMA', '', 2, 0.00, NULL, ''),
(5, '2025-11-01', 500000.00, 'PENDIENTE_FIRMA', '', 3, 1050.00, NULL, ''),
(8, '2025-11-01', 500000.00, 'PENDIENTE_FIRMA', '', 4, 0.00, NULL, ''),
(9, '2025-11-01', 500000.00, 'PENDIENTE_FIRMA', '', 10, 0.00, '2025-11-17 22:32:22.856655', 'firmas/firma_9.png'),
(10, '2025-11-01', 500000.00, 'PENDIENTE_FIRMA', '', 1, 135.00, NULL, ''),
(11, '2025-11-01', 500000.00, 'PENDIENTE_FIRMA', '', 11, 0.00, NULL, ''),
(12, '2025-11-01', 500000.00, 'PENDIENTE_FIRMA', '', 12, 0.00, NULL, ''),
(13, '2025-11-01', 900000.00, 'PENDIENTE_FIRMA', '', 13, 0.00, '2025-11-18 17:40:28.153646', 'firmas/firma_13.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apptica_registroasistencia`
--

CREATE TABLE `apptica_registroasistencia` (
  `id` bigint(20) NOT NULL,
  `fecha` date NOT NULL,
  `hora_entrada` time(6) DEFAULT NULL,
  `hora_salida` time(6) DEFAULT NULL,
  `estado` varchar(10) NOT NULL,
  `empleado_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `apptica_registroasistencia`
--

INSERT INTO `apptica_registroasistencia` (`id`, `fecha`, `hora_entrada`, `hora_salida`, `estado`, `empleado_id`) VALUES
(2, '2025-11-01', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(3, '2025-11-02', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(4, '2025-11-03', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(5, '2025-11-04', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(6, '2025-11-05', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(7, '2025-11-06', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(8, '2025-11-07', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(9, '2025-11-08', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(10, '2025-11-09', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(11, '2025-11-10', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(12, '2025-11-11', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(13, '2025-11-12', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(14, '2025-11-13', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(15, '2025-11-14', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(16, '2025-11-15', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(17, '2025-11-16', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(18, '2025-11-17', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(19, '2025-11-18', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(20, '2025-11-19', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(21, '2025-11-20', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(22, '2025-11-21', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(23, '2025-11-22', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(24, '2025-11-23', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(25, '2025-11-24', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(26, '2025-11-25', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(27, '2025-11-26', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(28, '2025-11-27', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(29, '2025-11-28', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(30, '2025-11-29', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(31, '2025-11-30', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 1),
(32, '2025-11-01', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(33, '2025-11-02', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(34, '2025-11-03', NULL, NULL, 'AUSENTE', 2),
(35, '2025-11-04', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(36, '2025-11-05', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(37, '2025-11-06', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(38, '2025-11-07', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(39, '2025-11-08', NULL, NULL, 'AUSENTE', 2),
(40, '2025-11-09', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(41, '2025-11-10', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(42, '2025-11-11', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(43, '2025-11-12', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(44, '2025-11-13', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(45, '2025-11-14', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(46, '2025-11-15', NULL, NULL, 'AUSENTE', 2),
(47, '2025-11-16', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(48, '2025-11-17', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(49, '2025-11-18', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(50, '2025-11-19', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(51, '2025-11-20', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(52, '2025-11-21', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(53, '2025-11-22', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(54, '2025-11-23', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(55, '2025-11-24', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(56, '2025-11-25', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(57, '2025-11-26', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(58, '2025-11-27', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(59, '2025-11-28', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(60, '2025-11-29', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2),
(61, '2025-11-30', '09:00:00.000000', '18:00:00.000000', 'PRESENTE', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apptica_solicitudvacacional`
--

CREATE TABLE `apptica_solicitudvacacional` (
  `id` bigint(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `dias` int(11) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `empleado_id` bigint(20) NOT NULL,
  `fecha_solicitud` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `apptica_solicitudvacacional`
--

INSERT INTO `apptica_solicitudvacacional` (`id`, `fecha_inicio`, `fecha_fin`, `dias`, `estado`, `empleado_id`, `fecha_solicitud`) VALUES
(7, '2025-11-18', '2025-11-21', 4, 'RECHAZADA', 12, '2025-11-18 16:08:50.626949'),
(8, '2025-11-18', '2025-11-21', 4, 'PENDIENTE', 13, '2025-11-18 18:42:44.273126');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apptica_venta`
--

CREATE TABLE `apptica_venta` (
  `id` bigint(20) NOT NULL,
  `fecha` date NOT NULL,
  `monto` decimal(14,2) NOT NULL,
  `empleado_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `apptica_venta`
--

INSERT INTO `apptica_venta` (`id`, `fecha`, `monto`, `empleado_id`) VALUES
(1, '2025-11-14', 10000.00, 2),
(2, '2025-11-15', 1000000.00, 1),
(10, '2025-11-15', 30000.00, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add empleado', 7, 'add_empleado'),
(26, 'Can change empleado', 7, 'change_empleado'),
(27, 'Can delete empleado', 7, 'delete_empleado'),
(28, 'Can view empleado', 7, 'view_empleado'),
(29, 'Can add comision venta', 8, 'add_comisionventa'),
(30, 'Can change comision venta', 8, 'change_comisionventa'),
(31, 'Can delete comision venta', 8, 'delete_comisionventa'),
(32, 'Can view comision venta', 8, 'view_comisionventa'),
(33, 'Can add liquidacion', 9, 'add_liquidacion'),
(34, 'Can change liquidacion', 9, 'change_liquidacion'),
(35, 'Can delete liquidacion', 9, 'delete_liquidacion'),
(36, 'Can view liquidacion', 9, 'view_liquidacion'),
(37, 'Can add registro asistencia', 10, 'add_registroasistencia'),
(38, 'Can change registro asistencia', 10, 'change_registroasistencia'),
(39, 'Can delete registro asistencia', 10, 'delete_registroasistencia'),
(40, 'Can view registro asistencia', 10, 'view_registroasistencia'),
(41, 'Can add solicitud vacacional', 11, 'add_solicitudvacacional'),
(42, 'Can change solicitud vacacional', 11, 'change_solicitudvacacional'),
(43, 'Can delete solicitud vacacional', 11, 'delete_solicitudvacacional'),
(44, 'Can view solicitud vacacional', 11, 'view_solicitudvacacional'),
(45, 'Can add venta', 12, 'add_venta'),
(46, 'Can change venta', 12, 'change_venta'),
(47, 'Can delete venta', 12, 'delete_venta'),
(48, 'Can view venta', 12, 'view_venta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1000000$7yUuZXYrVcAa0uvnB5f2NV$PLrL28zYl6SFFHAsABByrkttm4a+9R3glQm6CXOB33k=', '2025-10-27 02:52:22.305750', 1, 'belen', '', '', 'belen@inacap.cl', 1, 1, '2025-10-27 02:44:35.106879'),
(10, 'pbkdf2_sha256$600000$9Qe0lTANRG3kMdsIcCkdsU$MFIlmWgfgCZCQYwBMF5wxVFJr1kClxjXm2+10yaQfNg=', '2025-11-18 18:43:17.485824', 1, 'doki', '', '', 'doki@empresa.cl', 1, 1, '2025-11-17 17:05:08.000000'),
(11, 'pbkdf2_sha256$600000$FLM1CO6uIoKSw5lfbBNYOm$XYFI9Ous1VAwE72n4t65RPEbwuzUWVvSnx325WWyb7A=', '2025-11-18 05:20:56.539403', 0, 'mremetea', '', '', 'mremetea@gmail.com', 1, 1, '2025-11-17 23:21:46.576657'),
(12, 'pbkdf2_sha256$600000$0fnjggnGcpYlmjQdEPAJ2v$TXRsdQsCuIFBQE61WPHHbaFbW/E5zXadLw5lrNB7F2M=', '2025-11-18 18:46:54.327285', 0, 'awffaw', '', '', 'awffaw@gmail.com', 1, 1, '2025-11-18 04:41:39.361822'),
(13, 'pbkdf2_sha256$600000$3Vg4OHoe7U67v6jbP9HzV5$tGLkW7Cs5gXMRDwKSvELekaEJEtcAFyOtMtjImAF5eo=', '2025-11-18 18:41:55.264647', 0, 'Juan', '', '', 'Juan@gmail.com', 1, 1, '2025-11-18 16:40:07.572302'),
(14, 'pbkdf2_sha256$600000$3li1YI4jP34JOipRRsN6qS$9yzk5nik0iKVDswytzS1sZnkJZdNshP+KSzUxQVzRWY=', '2025-11-18 18:46:04.261983', 0, 'basti', '', '', 'basti@gmail.com', 1, 1, '2025-11-18 18:45:48.088576');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(8, 'apptica', 'comisionventa'),
(7, 'apptica', 'empleado'),
(9, 'apptica', 'liquidacion'),
(10, 'apptica', 'registroasistencia'),
(11, 'apptica', 'solicitudvacacional'),
(12, 'apptica', 'venta'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-10-27 02:43:47.060750'),
(2, 'auth', '0001_initial', '2025-10-27 02:43:47.294066'),
(3, 'admin', '0001_initial', '2025-10-27 02:43:47.339338'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-10-27 02:43:47.344339'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-10-27 02:43:47.347269'),
(6, 'apptica', '0001_initial', '2025-10-27 02:43:47.461548'),
(7, 'contenttypes', '0002_remove_content_type_name', '2025-10-27 02:43:47.501722'),
(8, 'auth', '0002_alter_permission_name_max_length', '2025-10-27 02:43:47.516781'),
(9, 'auth', '0003_alter_user_email_max_length', '2025-10-27 02:43:47.532930'),
(10, 'auth', '0004_alter_user_username_opts', '2025-10-27 02:43:47.537932'),
(11, 'auth', '0005_alter_user_last_login_null', '2025-10-27 02:43:47.559558'),
(12, 'auth', '0006_require_contenttypes_0002', '2025-10-27 02:43:47.560557'),
(13, 'auth', '0007_alter_validators_add_error_messages', '2025-10-27 02:43:47.564558'),
(14, 'auth', '0008_alter_user_username_max_length', '2025-10-27 02:43:47.580974'),
(15, 'auth', '0009_alter_user_last_name_max_length', '2025-10-27 02:43:47.595519'),
(16, 'auth', '0010_alter_group_name_max_length', '2025-10-27 02:43:47.611182'),
(17, 'auth', '0011_update_proxy_permissions', '2025-10-27 02:43:47.616182'),
(18, 'auth', '0012_alter_user_first_name_max_length', '2025-10-27 02:43:47.634186'),
(19, 'sessions', '0001_initial', '2025-10-27 02:43:47.657387'),
(20, 'apptica', '0002_liquidacion_comisiones', '2025-11-16 01:03:50.306241'),
(21, 'apptica', '0003_venta', '2025-11-16 01:05:28.940451'),
(22, 'apptica', '0004_alter_comisionventa_comision_and_more', '2025-11-16 01:27:12.224541'),
(23, 'apptica', '0005_alter_comisionventa_comision_and_more', '2025-11-16 01:35:19.897153'),
(24, 'apptica', '0006_alter_comisionventa_comision', '2025-11-16 01:39:55.670729'),
(25, 'apptica', '0007_alter_liquidacion_comisiones_and_more', '2025-11-16 01:50:19.272208'),
(26, 'apptica', '0008_liquidacion_fecha_firma_liquidacion_firma_empleado', '2025-11-17 22:16:30.405979'),
(27, 'apptica', '0009_remove_solicitudvacacional_observacion_and_more', '2025-11-18 02:40:08.538834'),
(28, 'apptica', '0010_empleado_sueldo_fijo', '2025-11-18 16:37:50.074715');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('gcy7odajeqcm9n5u2plq8ztwves1232n', '.eJxVjDsOwjAQBe_iGllO_KekzxmsXa-NA8iW4qRC3J1ESgHtm5n3ZgG2tYStpyXMxK5sYJffDSE-Uz0APaDeG4-trsuM_FD4STufGqXX7XT_Dgr0stcWnfIgvbFi9DqDy44EGp2M8hKEl8khDtE5O2YQu6C8TVoCSIpkCdnnC9HOOBo:1vDDLK:v1C_YVExV2U2bOZVmvsiW-jmnC1qSJoxUL4e9Q9Bxi0', '2025-11-10 02:52:22.307751'),
('xan7r6txhh3pqaqtzvpfbhrsgzxito3n', '.eJxVj00SgjAMhe_StTK0lILudIZxoy68AJO0qaDQOvyMC8e7C8gCkt37Xl6SD8uh74q8b6nJS8P2jAu2WYoI-kluJOYB7u4D7V3XlBiMlmCmbXDxhqrj7F0FFNAWw7SkOEQuAFLkWpFGTHYpgUITWQRuwpgnNlRaCdRSSx7ZJLQ7pY01QkiBQyjVr4rA-OlQLhaC8zU2NGx5j7W0Nn03PfXvbbxivhrYKbtmt8OZfX-M2Ves:1vLQj8:FulQrcf7m4FUzsEkyhnsdRQa3mzXNcoQQi91IhaGP0g', '2025-12-02 18:46:54.338437');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `apptica_comisionventa`
--
ALTER TABLE `apptica_comisionventa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apptica_comisionvent_empleado_id_4ebb329f_fk_apptica_e` (`empleado_id`);

--
-- Indices de la tabla `apptica_empleado`
--
ALTER TABLE `apptica_empleado`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `rut` (`rut`);

--
-- Indices de la tabla `apptica_liquidacion`
--
ALTER TABLE `apptica_liquidacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apptica_liquidacion_empleado_id_bbd70ba8_fk_apptica_empleado_id` (`empleado_id`);

--
-- Indices de la tabla `apptica_registroasistencia`
--
ALTER TABLE `apptica_registroasistencia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apptica_registroasis_empleado_id_755d8f71_fk_apptica_e` (`empleado_id`);

--
-- Indices de la tabla `apptica_solicitudvacacional`
--
ALTER TABLE `apptica_solicitudvacacional`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apptica_solicitudvac_empleado_id_255ec1c4_fk_apptica_e` (`empleado_id`);

--
-- Indices de la tabla `apptica_venta`
--
ALTER TABLE `apptica_venta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apptica_venta_empleado_id_c62b6d72_fk_apptica_empleado_id` (`empleado_id`);

--
-- Indices de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indices de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indices de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indices de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indices de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indices de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `apptica_comisionventa`
--
ALTER TABLE `apptica_comisionventa`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `apptica_empleado`
--
ALTER TABLE `apptica_empleado`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `apptica_liquidacion`
--
ALTER TABLE `apptica_liquidacion`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `apptica_registroasistencia`
--
ALTER TABLE `apptica_registroasistencia`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `apptica_solicitudvacacional`
--
ALTER TABLE `apptica_solicitudvacacional`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `apptica_venta`
--
ALTER TABLE `apptica_venta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `apptica_comisionventa`
--
ALTER TABLE `apptica_comisionventa`
  ADD CONSTRAINT `apptica_comisionvent_empleado_id_4ebb329f_fk_apptica_e` FOREIGN KEY (`empleado_id`) REFERENCES `apptica_empleado` (`id`);

--
-- Filtros para la tabla `apptica_liquidacion`
--
ALTER TABLE `apptica_liquidacion`
  ADD CONSTRAINT `apptica_liquidacion_empleado_id_bbd70ba8_fk_apptica_empleado_id` FOREIGN KEY (`empleado_id`) REFERENCES `apptica_empleado` (`id`);

--
-- Filtros para la tabla `apptica_registroasistencia`
--
ALTER TABLE `apptica_registroasistencia`
  ADD CONSTRAINT `apptica_registroasis_empleado_id_755d8f71_fk_apptica_e` FOREIGN KEY (`empleado_id`) REFERENCES `apptica_empleado` (`id`);

--
-- Filtros para la tabla `apptica_solicitudvacacional`
--
ALTER TABLE `apptica_solicitudvacacional`
  ADD CONSTRAINT `apptica_solicitudvac_empleado_id_255ec1c4_fk_apptica_e` FOREIGN KEY (`empleado_id`) REFERENCES `apptica_empleado` (`id`);

--
-- Filtros para la tabla `apptica_venta`
--
ALTER TABLE `apptica_venta`
  ADD CONSTRAINT `apptica_venta_empleado_id_c62b6d72_fk_apptica_empleado_id` FOREIGN KEY (`empleado_id`) REFERENCES `apptica_empleado` (`id`);

--
-- Filtros para la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Filtros para la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Filtros para la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
