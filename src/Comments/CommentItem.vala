
namespace ReadIt.Comments { 

    public class CommentItem  : Gtk.Label {

        public string description { get; set; }

        public CommentItem(string description) {
            Object(
                description: description
            );
        }

        construct {
            height_request = 30; 
        }
    }
    
}