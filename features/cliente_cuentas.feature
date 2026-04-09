# language: es
@cliente
Feature: Información del cliente
  Como usuario autenticado
  Quiero consultar mis datos personales y resumen de cuentas
  Para tener visibilidad completa de mi situación financiera

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke
  Scenario: Obtener dashboard completo del cliente
    When consulto el dashboard en "GET /cliente/dashboard"
    Then la respuesta debe tener status code 200
    And la respuesta debe incluir los datos del cliente
    And el nombre del cliente debe ser "Juan Pérez"
    And la respuesta debe incluir la lista de cuentas
    And la respuesta debe incluir el saldo total
    And la respuesta debe incluir las últimas transacciones

  @alto @smoke
  Scenario: Obtener datos personales del cliente
    When consulto los datos personales en "GET /cliente/datos"
    Then la respuesta debe tener status code 200
    And el nombre debe ser "Juan Pérez"
    And el DNI debe ser "12.345.678"
    And el email debe ser "juan.perez@email.com"

  @alto
  Scenario: Verificar saldo total inicial del cliente
    When consulto el dashboard en "GET /cliente/dashboard"
    Then el saldo total debe ser 259771.25

  @alto
  Scenario: Rechazo por token de autenticación inválido
    Given el usuario está autenticado con token "token-invalido"
    When consulto el dashboard en "GET /cliente/dashboard"
    Then la respuesta debe tener status code 401


@cuentas
Feature: Consulta de cuentas bancarias
  Como usuario autenticado
  Quiero consultar el detalle de mis cuentas
  Para conocer mis saldos actualizados

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke
  Scenario: Consultar listado de cuentas del usuario
    When consulto las cuentas en "GET /cuentas/"
    Then la respuesta debe tener status code 200
    And la respuesta debe contener 3 cuentas
    And la lista debe incluir la cuenta "ACC001"
    And la lista debe incluir la cuenta "ACC002"
    And la lista debe incluir la cuenta "ACC003"

  @alto
  Scenario: Verificar saldos iniciales de las cuentas
    When consulto las cuentas en "GET /cuentas/"
    Then el saldo de "ACC001" debe ser 125450.75
    And el saldo de "ACC002" debe ser 89320.50
    And el saldo de "ACC003" debe ser 45000.00

  @alto
  Scenario: Verificar tipos de cuenta
    When consulto las cuentas en "GET /cuentas/"
    Then la cuenta "ACC001" debe ser de tipo "Cuenta Corriente"
    And la cuenta "ACC002" debe ser de tipo "Caja de Ahorro"
    And la cuenta "ACC003" debe ser de tipo "Tarjeta de Crédito"
