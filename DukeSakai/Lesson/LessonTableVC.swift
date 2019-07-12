
import UIKit
import WebKit

class LessonTableVC: UIViewController, WKUIDelegate{
    var textView = UITextView()
    var webView = WKWebView()
    var htmlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        htmlString = """
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
        <html>
        <head>
        
        <title>Our first HTML page</title>
        
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        
        </head>
        <body>
        
        <h2>Welcome to the web site: this is a heading inside of the heading tags.</h2>
        
        <p>This is a paragraph of text inside the paragraph HTML tags. We can just keep writting ...
        </p>
        
        <h3>Now we have an image:</h3>
        
        <div><img src="https://terrigen-cdn-dev.marvel.com/content/prod/1x/spider-manfarfromhome_lob_crd_04_0.jpg" alt="Just some test image"></div>
        
        <h3>
        This is another heading inside of another set of headings tags; this time the tag is an 'h3' instead of an 'h2' , that means it is a less important heading.
        </h3>
        
        <h4>Yet another heading - right after this we have an HTML list:</h4>
        
        <ol>
        <li>First item in the list</li>
        <li>Second item in the list</li>
        <li>Third item in the list</li>
        </ol>
        
        <p>You will notice in the above HTML list, the HTML automatically creates the numbers in the list.</p>
        
        <h3>About the list tags</h3>
        
        <p>
        HTML list tags are a little more complex than the other tags we have seen thus far. </p>
        
        <p>
        HTML list come in two flavors: ordered and unordered. Ordered list tags (<ol>) automatically inserts the right numbers for each of the list items (<li>), where as the unordered list tag (<ul>) inserts bullets.</p>
        
        <ul>
        <li>First item in the list</li>
        <li>Second item in the list</li>
        <li>Third item in the list</li>
        </ul>
        
        
        
        <h3>Now the most important HTML tag there is: the link tag!</h3>
        <p>
        This another web site worth visiting: <a href="http://www.killersites.com">www.killersites.com: Web design tutorials and forums</a>
        </p>
        
        </body>
        </html>
        """
        textView.attributedText = htmlString.htmlToAttributedString
        textView.frame = UIScreen.main.bounds
        textView.backgroundColor = UIColor.yellow
        
        webView.frame = UIScreen.main.bounds
        webView.backgroundColor = UIColor.gray
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        self.view.addSubview(webView)
        self.view.backgroundColor = UIColor.blue
        
        
    }
}
