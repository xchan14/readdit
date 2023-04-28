/*
* Copyright (c) 2020 Christian Camilon 
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Christian Camilon <christiancamilon@gmail.com>
*/

using Gee;

public class Readdit.Dispatcher : Object  {
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
        //stdout.printf("Dispatching action of type %s...\n", action.get_type().name());
        action_dispatched(action);
    }
}
