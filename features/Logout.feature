Feature: Cerrar sesion
  @Logout
  Scenario: Logout Exitoso
    Given el usuario ha iniciado sesion exitosamente
    And el usuario se encuentra en la pagina de Dashboard
    When el usuario hace click en boton salir
    And da click en el boton confirmar del modal de confirmacion
    Then el usuario es redirigido a la pagina de login