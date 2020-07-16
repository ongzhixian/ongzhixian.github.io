

npm install -g azure-functions-core-tools@3

https://azure.microsoft.com/en-us/free/

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-cli


https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#v2

/* Color Theme Swatches in Hex */
.Illustration-1-hex { color: #63A674; }
.Illustration-2-hex { color: #F2BE5C; }
.Illustration-3-hex { color: #F2D091; }
.Illustration-4-hex { color: #F2A88D; }
.Illustration-5-hex { color: #D94E4E; }

/* Color Theme Swatches in RGBA */
.Illustration-1-rgba { color: rgba(99, 165, 116, 1); }
.Illustration-2-rgba { color: rgba(242, 189, 92, 1); }
.Illustration-3-rgba { color: rgba(242, 208, 145, 1); }
.Illustration-4-rgba { color: rgba(242, 167, 140, 1); }
.Illustration-5-rgba { color: rgba(216, 78, 78, 1); }

/* Color Theme Swatches in HSLA */
.Illustration-1-hsla { color: hsla(135, 27, 52, 1); }
.Illustration-2-hsla { color: hsla(39, 85, 65, 1); }
.Illustration-3-hsla { color: hsla(39, 79, 76, 1); }
.Illustration-4-hsla { color: hsla(16, 79, 75, 1); }
.Illustration-5-hsla { color: hsla(0, 64, 57, 1); }



<div class="row">
    <div class="twelve columns">
        <h1 class="page-header">{{SITE_NAME}}
            {% if sub_title|length > 0 %}
            <small>&mdash; {{sub_title}}</small>
            {% endif %}
        </h1>
        <nav class="top-navbar">
            {% for item in menu_items %}
            {% if active_text == item.text %}
            <a href="{{item.href}}" class="active">{{item.text}}</a>
            {% else %}
            <a href="{{item.href}}">{{item.text}}</a>
            {% endif %}
            {%- endfor %}
            
            <!--
                <div class="dropdown">
                    <a href="javascript:void(0);" class="dropdown-button" onclick="myFunction('myDropdown')">Tests
                        <i class="fa fa-caret-down"></i>
                    </a>
                    <div class="dropdown-content" id="myDropdown">
                        <a href="/test1">Test 1</a>
                        <a href="/test2">Test 2</a>
                        <a href="/test3">Test 3</a>
                    </div>
                </div>
            -->
                
        </nav>
    </div>
</div><!--end of .row .twelve.columns -->
