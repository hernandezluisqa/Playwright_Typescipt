Feature: Transferencias entre cuentas propias y a terceros

  Background: Login y navegacion a Transferencias
    Given el usuario ha iniciado sesion satisfactoriamente
    And el usuario se encuentra en la pagina de Dashboard
    And el usuario guarda el saldo inicial de sus cuentas
    And el usuario hace click en el boton "Transferencias" del menu lateral

  @Regression
  Scenario Outline: Transferencia exitosa entre cuentas propias con montos límite
    When el usuario selecciona tipo de transferencia "Entre mis cuentas"
    And selecciona cuenta origen "<origen>"
    And selecciona cuenta destino "<destino>"
    And ingresa monto "<monto>"
    And presiona TRANSFERIR
    And Verifica que se muestra el popup de confirmacion con los detalles correctos de la transferencia
    And confirma la transferencia
    Then se visualiza mensaje "Transferencia realizada exitosamente"
    And en la pagina de dashboard se refleja el nuevo saldo de las cuentas

    Examples:
      | origen    | destino   | monto   |
      | Corriente | Ahorro    | 1.00    |
      | Ahorro    | Corriente | 50000   |

  Scenario Outline: Transferencia exitosa a terceros
    Given el usuario selecciona tipo de transferencia "A terceros"
    And ingresa un destino válido "<destino>"
    When ingresa monto "<monto>"
    And presiona "TRANSFERIR"
    And Verifica que se muestra el popup de confirmacion con los detalles correctos de la transferencia
    And hace click en el boton "Confirmar" del popup de confirmacion
    Then se visualiza mensaje "Transferencia realizada exitosamente"

    Examples:
      | destino         | monto   |
      | 1234567890      | 1.00    |
      | Mi_Alias_0      | 50000   | 
      | 12345678901     | 1.00    | 

  Scenario: Transferencias acumuladas dentro del límite diario
    Given el usuario ya transfirió "$99.999" en el día
    When el usuario selecciona tipo de transferencia "Entre mis cuentas"
    And selecciona cuenta origen "<origen>"
    And selecciona cuenta destino "<destino>"
    And intenta transferir "1.00"
    And presiona "TRANSFERIR"
    And Verifica que se muestra el popup de confirmacion con los detalles correctos de la transferencia
    And hace click en el boton "Confirmar" del popup de confirmacion
    Then se visualiza mensaje "Transferencia realizada exitosamente"

  Scenario Outline: Validación de montos inválidos
    When el usuario ingresa monto "<monto>"
    And presiona "TRANSFERIR"
    Then se muestra mensaje "<mensaje>"

    Examples:
      | monto    | mensaje                                               |
      | 0.99     | El monto mínimo es $1.00                              |
      | 50000.01 | El monto máximo por transferencia es $50,000.00       |
      | -1       | El monto debe ser positivo                            |
      | abc      | El monto debe ser numérico                            |

  Scenario: Transferencias acumuladas superan límite diario
    Given el usuario ya transfirió "$100,000.00" en el día
    When intenta transferir "100,000.01"
    Then se muestra mensaje "Límite diario acumulado $100,000.00 superado"

  Scenario: Transferencia con saldo insuficiente
    Given la cuenta origen tiene saldo "$500"
    When el usuario intenta transferir "1000"
    Then se muestra mensaje "Saldo insuficiente en cuenta origen"

  Scenario Outline: Transferencia inválida entre la misma cuenta
    Given el usuario selecciona tipo de transferencia "Entre mis cuentas"
    And selecciona cuenta origen "<origen>"
    And selecciona cuenta destino "<destino>"
    When ingresa monto "<monto>"
    And presiona "TRANSFERIR"
    Then se muestra mensaje "No se permiten transferencias entre la misma cuenta"

    Examples:
      | origen    | destino   | monto   |
      | Ahorro    | Ahorro    | 1       |
      | Corriente | Corriente | 1       |

  Scenario Outline: Transferencia inválida a terceros
    Given el usuario selecciona tipo de transferencia "A terceros"
    When ingresa cuenta de origen "<origen>"
    And ingresa un destino "<destino>"
    When ingresa monto "<monto>"
    And presiona "TRANSFERIR"
    Then se muestra mensaje "<mensaje>"

    Examples:
      | origen    | destino    | monto   | mensaje                 |
      | Corriente | 123456789  |   1     | Cuenta destino inválida |
      | Ahorro    | Mi_Alias1  |   1     | Cuenta destino inválida |
      | Corriente | 123 567890 |   1     | Cuenta destino inválida |
      | Corriente | 10 spaces  |   1     | Cuenta destino inválida |