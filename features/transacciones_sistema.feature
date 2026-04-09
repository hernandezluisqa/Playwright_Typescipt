# language: es
@transacciones
Feature: Historial de transacciones
  Como usuario autenticado
  Quiero consultar mi historial de movimientos
  Para llevar un registro de todas mis operaciones

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke
  Scenario: Consultar historial de transacciones con límite por defecto
    When consulto las transacciones en "GET /transacciones/"
    Then la respuesta debe tener status code 200
    And la respuesta debe ser una lista
    And la lista debe contener como máximo 10 transacciones

  @alto
  Scenario: Consultar historial de transacciones con límite personalizado
    When consulto las transacciones con parámetro "limit" igual a 5
    Then la respuesta debe tener status code 200
    And la lista debe contener como máximo 5 transacciones

  @alto
  Scenario: Las transacciones reflejan operaciones recientes
    Given he realizado una transferencia de 1000.00 desde "ACC001" a "ACC002"
    When consulto las transacciones en "GET /transacciones/"
    Then la transacción más reciente debe ser de tipo "debit"
    And el monto debe ser 1000.00

  @medio
  Scenario: El historial se actualiza tras múltiples operaciones
    Given he realizado las siguientes operaciones:
      | operacion    | monto    | cuenta |
      | transferencia| 2000.00  | ACC001 |
      | pago         | 8500.00  | ACC001 |
    When consulto las transacciones en "GET /transacciones/"
    Then la lista debe incluir las 2 operaciones realizadas


@sistema
Feature: Sistema y gestión de datos
  Como usuario autenticado
  Quiero poder reiniciar los datos del sistema
  Para comenzar pruebas desde un estado limpio conocido

  Background:
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @bajo @smoke
  Scenario: Resetear el sistema a su estado inicial
    Given el sistema tiene datos modificados por operaciones previas
    When ejecuto el reset en "POST /sistema/reset"
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser true
    And el saldo de "ACC001" debe ser 125450.75
    And el saldo de "ACC002" debe ser 89320.50
    And el saldo de "ACC003" debe ser 45000.00

  @bajo
  Scenario: El reset elimina plazos fijos creados durante la sesión
    Given he creado un plazo fijo activo durante la sesión
    When ejecuto el reset en "POST /sistema/reset"
    Then la lista de plazos fijos debe estar vacía

  @bajo
  Scenario: El reset elimina préstamos creados durante la sesión
    Given he solicitado un préstamo durante la sesión
    When ejecuto el reset en "POST /sistema/reset"
    Then la lista de préstamos debe estar vacía

  @bajo
  Scenario: El reset elimina tarjetas virtuales creadas durante la sesión
    Given he generado una tarjeta virtual durante la sesión
    When ejecuto el reset en "POST /sistema/reset"
    Then la lista de tarjetas virtuales debe estar vacía
