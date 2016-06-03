function showForm(){

    var formCollection = document.getElementsByTagName("form");
    var form;
    for(form in formCollection){
        form.style.visibility = "visible";
    }
}

function wrongPassword(){
    alert("Wrong username or password. Please try again.")
}

function showAddItemDiv(id){

    var form = document.getElementById("add_item_div_"+id);
        form.style.display = "block";
}

function showOrHide(name){
    var formCollection = document.getElementsByName(name);
    var option = "visible"
    var option2 = "block"
    if (formCollection[0].style.visibility === option){
        option = "hidden";
        option2 = "none";
    }
    for(var i = 0; i < formCollection.length; i++){
        formCollection[i].style.visibility = option;
        formCollection[i].style.display = option2;
    }

}

function submit(name){
        $("."+ name).submit();
}


function show(name){
    var formCollection = document.getElementsByName(name);
    for(var i = 0; i < formCollection.length; i++){
        formCollection[i].style.visibility = "visible";
        formCollection[i].style.display = "block";
    }
}

function hide(name){
    var formCollection = document.getElementsByName(name);
    for(var i = 0; i < formCollection.length; i++){
        formCollection[i].style.visibility = "hidden";
        formCollection[i].style.visibility = "none";
    }
}



