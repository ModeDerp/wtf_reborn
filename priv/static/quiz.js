let students = [];
let availableGuesses = [];
let length = 0;
let counter = 0;
let currentGuess = {};
let guessed = true;
let correct = 0;

const qs = (el) => {
    return document.querySelector(el);
}

fetch("/json/"+id).then(res => {
    res.json().then(json => {
        students = json;
        length = students.length;

        console.log(students);

        nextGuess();
    })
});

const nextGuess = () => {
    if(counter < length){
        if(guessed){
            Object.assign(availableGuesses, students)
            currentGuess = students[counter];
            guessed = false;
    
            appendAnswers();
            appendImage();
    
            counter++;
        } else {
            console.log("You haven't guessed yet");
        }
    } else{
        appendResults();
    } 
}

const appendImage = () => {
    qs(".quiz-image").children[0].setAttribute("src", "/uploads/" + students[counter].img)
}

const appendAnswers = () => {
    qs(".quiz-answers").innerHTML = "";
    for(guess of shuffle(availableGuesses)){
        qs(".quiz-answers").insertAdjacentHTML("beforeend", `<div class="quiz-answer" onclick="handleGuess(this, ${guess.id})"><span>${guess.first_name + " " + guess.last_name}</span></div>`)
    }
}

const handleGuess = (el, id) => {
    if(!guessed){
        guessed = true;
        if(id == currentGuess.id) correctGuess(el);
        else incorrectGuess(el);
    } else {
        console.log("You have already made your guess!");
    }
}

correctGuess = el => {
    correct += 1;
    el.classList.add("correct");
}

incorrectGuess = el => {
    el.classList.add("incorrect");
}

appendResults = () => {
    qs(".quiz-container").innerHTML = "";
    qs(".quiz-container").insertAdjacentHTML("beforeend", `<div class="title"><h1>Du hade ${correct + " / " + length} rätt!</h1></div>`)
}

const shuffle = (a) => {
    var j, x, i;
    for (i = a.length - 1; i > 0; i--) {
        j = Math.floor(Math.random() * (i + 1));
        x = a[i];
        a[i] = a[j];
        a[j] = x;
    }
    return a;
}