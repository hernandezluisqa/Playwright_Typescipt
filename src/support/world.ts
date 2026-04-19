import { setWorldConstructor, World, IWorldOptions } from "@cucumber/cucumber";
import { Browser, Page } from "@playwright/test";
import { TransferenciaPage } from "../pages/TransferenciaPage";
import { SideBarPage } from "../pages/SideBarPage";
import { ProfilePage } from "../pages/ProfilePage";
import { LoginPage } from "../pages/LoginPage";

export class CustomWorld extends World {
  browser: Browser | undefined;
  page: Page | undefined;

  // Page Objects
  transferenciaPage?: TransferenciaPage;
  profilePage?: ProfilePage;
  sideBarPage?: SideBarPage;
  loginPage?: LoginPage;

  // Datos del usuario
  username?: string;
  password?: string;

  // Datos del escenario
  tipoTransferencia: string = "";
  cuentaOrigen: string = "";
  cuentaDestino: string = "";
  montoIngresado: number = 0;
  descripcion?: string;
  saldoInicialCuentaCorriente?: number;
  saldoInicialCuentaAhorro?: number;

  constructor(options: IWorldOptions) {
    super(options);
  }
}

setWorldConstructor(CustomWorld);
