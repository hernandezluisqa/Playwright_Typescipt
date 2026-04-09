# language: es
@integracion @e2e
Feature: Flujos end-to-end de integración
  Como usuario autenticado
  Quiero ejecutar flujos completos de negocio
  Para validar la consistencia de datos entre módulos

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @critico @e2e
  Scenario: Flujo completo de plazo fijo: crear, consultar y cancelar
    Given la cuenta "ACC001" tiene saldo de 125450.75
    When creo un plazo fijo con los siguientes datos:
      | cuenta_origen | ACC001   |
      | monto         | 20000.00 |
      | plazo_dias    | 30       |
    Then el campo "exito" debe ser true
    And el saldo de "ACC001" debe ser 105450.75
    When consulto los plazos fijos en "GET /plazos-fijos/"
    Then el plazo fijo creado debe aparecer en la lista con estado "active"
    When cancelo el plazo fijo con ese ID
    Then el campo "exito" debe ser true
    And el saldo de "ACC001" debe ser 125450.75
    And el plazo fijo debe estar en estado "cancelled"

  @critico @e2e
  Scenario: Flujo completo de préstamo: solicitar y verificar acreditación
    Given la cuenta "ACC001" tiene un saldo registrado
    When solicito un préstamo con los siguientes datos:
      | monto          | 100000.00 |
      | cuotas         | 12        |
      | cuenta_destino | ACC001    |
    Then el campo "exito" debe ser true
    And el saldo de "ACC001" debe haber aumentado en 100000.00
    When consulto los préstamos en "GET /prestamos/"
    Then el préstamo debe aparecer en la lista como activo

  @alto @e2e
  Scenario: Flujo completo de tarjeta virtual: crear, consultar y eliminar
    When genero una tarjeta virtual con los siguientes datos:
      | id_cuenta_asociada | ACC002 |
    Then el campo "exito" debe ser true
    And la tarjeta debe tener estado "active"
    When consulto las tarjetas en "GET /tarjetas/virtuales"
    Then la tarjeta creada debe aparecer en la lista
    When elimino la tarjeta virtual con ese ID
    Then la respuesta debe tener status code 200
    When consulto las tarjetas en "GET /tarjetas/virtuales"
    Then la tarjeta eliminada no debe aparecer en la lista

  @alto @e2e
  Scenario: Verificar que una transferencia genera transacción en el historial
    Given el historial de transacciones tiene N registros
    When realizo una transferencia con los siguientes datos:
      | cuenta_origen  | ACC001  |
      | cuenta_destino | ACC002  |
      | monto          | 1500.00 |
      | tipo           | propia  |
    Then el campo "exito" debe ser true
    When consulto las transacciones en "GET /transacciones/"
    Then el historial debe tener N+1 registros
    And la transacción más reciente debe ser de tipo "debit" por 1500.00

  @alto @e2e
  Scenario: Verificar que un pago genera transacción en el historial
    Given el historial de transacciones tiene N registros
    When realizo un pago con los siguientes datos:
      | id_servicio | SRV002  |
      | monto       | 4200.00 |
      | id_cuenta   | ACC001  |
    Then el campo "exito" debe ser true
    When consulto las transacciones en "GET /transacciones/"
    Then el historial debe tener N+1 registros

  @medio @e2e
  Scenario: Reset restaura estado y permite reiniciar suite
    Given he realizado múltiples operaciones durante la sesión
    When ejecuto el reset en "POST /sistema/reset"
    Then el saldo de "ACC001" debe ser 125450.75
    And el saldo de "ACC002" debe ser 89320.50
    And la lista de plazos fijos debe estar vacía
    And la lista de préstamos debe estar vacía
    And la lista de tarjetas virtuales debe estar vacía
