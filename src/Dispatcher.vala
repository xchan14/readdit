using Gee;

public class ReadIt.Dispatcher : Object  {
    private static Dispatcher _instance;
    public delegate void ActionCallback(Action action);

    public signal void action_dispatched(Action action);

    public static Dispatcher INSTANCE {
        get {
            if(_instance == null) {
                _instance = new Dispatcher();
            }  
            return _instance;
        }
    }

    public void dispatch(Action action) {
        action_dispatched(action);
    }
}