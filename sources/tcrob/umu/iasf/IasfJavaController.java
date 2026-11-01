/*
 * (c) 2006 Humberto Martinez
 * Modificado para la práctica 1 (Roombo): limpia suelos
 */

package tcrob.umu.iasf;

import tc.runtime.thread.ModuleConfig;
import tc.modules.*;
import tc.shared.lps.lpo.*;
import tc.shared.linda.*;
import wucore.utils.logs.*;
import wucore.utils.math.Angles;

public class IasfJavaController extends Controller
{
  static public final String PREFFIX = "CNTL_";

  // Controller debug
  protected LogPlot c_plot;
  protected double[] c_buffer;
  protected String[] c_labels;

  // Estado del giro de emergencia (rebote aleatorio)
  protected int extra = 0;      // ciclos extra de giro restantes
  protected double dir = 1.0;   // +1 izquierda, -1 derecha

  // Constructors
  public IasfJavaController (ModuleConfig cfg, Linda linda)
  {
    super (cfg, linda);
  }

  // Instance methods
  protected void initialise (ModuleConfig cfg)
  {
    super.initialise (cfg);

    // Initialize debug modules
    c_buffer = new double[3];
    c_labels = new String[3]; // the three velocities of the control action
    c_labels[0] = "vlin";
    c_labels[1] = "vlat";
    c_labels[2] = "vrot";
    c_plot = new LogPlot ("Controller Output", "step", "m/s");
    if (localgfx)
      openMotionPlot (c_plot, c_labels); // the window, with its scales as far as the platform goes
  }

  /**
  The program starts afresh: the interpreter forgets what it had worked out and
  there is no goal, no plan and no path any more (RESET). Whether it runs from
  the first cycle again is what AUTO says, as when the module was set up.
  */
  protected void reset ()
  {
    super.reset ();
    extra = 0;
    dir = 1.0;
  }

  protected void controller ()
  {
    LPOSensorGroup group;
    double group0, group1, group2, group3, group4;
    double vlin, vlat, vrot;

    /* ----------- */
    /* CONTROLLER  */
    /* ----------- */

    // Read sensor values
    group = (LPOSensorGroup) lps.find ("Group");
    group0 = group.range[0];   // izquierda
    group1 = group.range[1];   // diagonal izquierda
    group2 = group.range[2];   // frente
    group3 = group.range[3];   // diagonal derecha
    group4 = group.range[4];   // derecha

    // Set action values
    vlin = 0.30;
    vlat = 0.0;
    vrot = 0.0;

    if (group2 < 0.20 || extra > 0)
    {
      // Obstaculo de frente: parar y girar hacia el lado con mas espacio
      if (extra <= 0)
      {
        dir = (group1 > group3 ? 1.0 : -1.0);
        extra = (int) (Math.random () * 15);   // giro extra aleatorio
      }
      else
        extra--;
      vlin = 0.0;
      vrot = dir * 150.0 * (0.7 + 0.3 * Math.random ());
    }
    else if (group1 < 0.20)
    {
      vlin = 0.0;
      vrot = -30.0;
    }
    else if (group0 < 0.25)
    {
      vlin = 0.2;
      vrot = -15.0;
    }
    else if (group3 < 0.20)
    {
      vlin = 0.0;
      vrot = 30.0;
    }
    else if (group4 < 0.25)
    {
      vlin = 0.2;
      vrot = 15.0;
    }
    else if (group2 < 0.30)
    {
      vlin = 0.15;   // frenar antes de llegar a la pared
    }

    // Set action (vrot is said in deg/s, the platform takes rad/s)
    setMotion (vlin, vlat, vrot*Angles.DTOR);

    // Plot current control commands
    if (localgfx)
    {
      motionValues (c_buffer, vlin, vlat, vrot);
      c_plot.draw (c_buffer);
    }
  }

  protected void close_gfx ()
  {
    if (c_plot != null) c_plot.close ();
  }

  /** The plot of the control action. */
  protected void open_gfx ()
  {
    openMotionPlot (c_plot, c_labels);
  }

  public void step (long ctime)
  {
    if (state != RUN) return;
    if (!auto || (lps == null)) return;

    // Run controller
    controller ();
  }
}