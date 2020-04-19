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

using ReaddIt.Users;
using Gee;

namespace ReaddIt.DataStores {

    public class UserStore : GLib.Object {

        private static Collection<User> _cached_users = new Gee.ArrayList<User>();

        public Collection<User> get_user_data_by_ids(string[] ids) {
            string concatIds = "";
            foreach(string id in ids) {
                concatIds = concatIds.concat(",", id);
            }
            concatIds = concatIds.substring(1);

            var session = new Soup.Session();
            string url = "https://reddit.com/api/user_data_by_account_ids.json?ids=" + concatIds;
            var message = new Soup.Message("GET", url);

            var users = new Gee.ArrayList<User>();
            session.send_message(message); 
            string data = (string)message.response_body.flatten().data;
            try {
                var parser = new Json.Parser();
                parser.load_from_data(data, -1);
                Json.Object root_object = parser.get_root ().get_object ();

                root_object.foreach_member((obj, name, node) => {
                    var account_data = node.get_object();
                    stdout.printf(name);
                    var user = new User();
                    user.id = name;
                    user.name = account_data.get_string_member("name");
                    user.profile_image_url = account_data.get_string_member("profile_img");
                    users.add(user);
                });
            } catch(Error e) {
                stdout.printf("Error: %s\n", e.message);
            }

            // Cache users if not yet cached.
            foreach(User user in users) {
                bool user_exists = false;
                foreach(User cached_user in _cached_users) {
                    if(user.id == cached_user.id) {
                        user_exists = true;
                        break;
                    }
                }
                if(user_exists) {
                    continue;
                }

                _cached_users.add(user);
            }

            return users;
        }

        public User get_user(string id) {
            stdout.printf("Getting user by id %s\n", id);
            User existing_user = null;
            foreach(User user in _cached_users) {
                if(user.id == id) {
                    existing_user = user;
                    break;
                }
            }

            if(existing_user != null) {
                stdout.printf("User exists and being returned.\n");
                return existing_user;
            }

            stdout.printf("Getting user from server if not existing...\n");

            Collection<User> users = get_user_data_by_ids(new string[] { id });

            existing_user = users.to_array()[0]; 
            return existing_user;
        }
    }
    
}