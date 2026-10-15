let STATO_FORUM = {
    isAdmin: false,
    nomeAdmin: "",
    nomeForum: "",
    isIscritto: false,
    totaleIscritti: 0,
    totalePost: 0,
    topics: [],
    posts: [] 
};

let idPostInModifica = null; 

// DOM
let areaPulsanti, menuAmministrazione;
let topicFiltri, topicCreazione;
let overlay, dialogTopic, btnApriTopic, btnChiudiTopic, formCreazioneTopic, errCreazioneTopic, inputCreazioneTopic;
let feedCentrale;
let boxDestra, formNuovoPost, btnChiudiDestra, errInvioPost;
let spanTitolo, linkAdmin, spanIscritti, spanPost;
let titoloFormDestro, btnInviaFormDestro;