# language: es
@pagos
Feature: Pago de servicios
  Como usuario autenticado
  Quiero pagar mis servicios desde la app
  Para gestionar mis gastos fijos de forma centralizada

  Background:
    Given el sistema está inicializado con datos de prueba
    And el usuario "demo" está autenticado con token "mock-token-demo"

  @alto @smoke @TC-PAY-001
  Scenario: Pago exitoso de servicio de electricidad
    Given la cuenta "ACC001" tiene saldo suficiente
    When realizo un pago con los siguientes datos:
      | id_servicio | SRV001  |
      | monto       | 8500.00 |
      | id_cuenta   | ACC001  |
    Then la respuesta debe tener status code 200
    And el campo "exito" debe ser true
    And se debe haber generado un comprobante con ID único
    And el saldo de "ACC001" debe haber disminuido en 8500.00

  @alto
  Scenario Outline: Pago exitoso de distintos servicios disponibles
    Given la cuenta "ACC001" tiene saldo suficiente
    When realizo un pago con los siguientes datos:
      | id_servicio | <id_servicio> |
      | monto       | <monto>       |
      | id_cuenta   | ACC001        |
    Then el campo "exito" debe ser true
    And el saldo de "ACC001" debe haber disminuido en <monto>

    Examples:
      | id_servicio | monto    | servicio          |
      | SRV001      | 8500.00  | Electricidad      |
      | SRV002      | 4200.00  | Gas Natural       |
      | SRV003      | 2800.00  | Agua              |
      | SRV004      | 12000.00 | Internet          |
      | SRV005      | 6500.00  | Telefonía         |

  @medio
  Scenario: Rechazo de pago por saldo insuficiente
    When realizo un pago con los siguientes datos:
      | id_servicio | SRV001    |
      | monto       | 999999.00 |
      | id_cuenta   | ACC001    |
    Then el campo "exito" debe ser false
    And el campo "error" debe ser "FONDOS_INSUFICIENTES"

  @medio
  Scenario: Rechazo de pago con servicio inexistente
    When realizo un pago con los siguientes datos:
      | id_servicio | SRV999  |
      | monto       | 1000.00 |
      | id_cuenta   | ACC001  |
    Then el campo "exito" debe ser false

  @alto @smoke
  Scenario: Consultar lista de servicios disponibles para pago
    When consulto los servicios en "GET /pagos/servicios"
    Then la respuesta debe tener status code 200
    And la respuesta debe contener al menos 5 servicios
    And la lista debe incluir el servicio con ID "SRV001"
