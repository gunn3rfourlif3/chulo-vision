const triggers = {
    zulu: ['ingozi', 'hulp'],
    afrikaans: ['gevaar', 'nood', 'hulp'],
    english: ['danger', 'emergency', 'help', 'sos']
};
module.exports = {
    scan: (text) => {
        if (!text) return { hit: false, stress: 0 };
        const hits = Object.keys(triggers).flatMap(l => triggers[l].filter(w => text.toLowerCase().includes(w)));
        const stress = hits.length === 1 ? 3 : hits.length === 2 ? 7 : hits.length >= 3 ? 10 : 0;
        return { hit: hits.length > 0, stress, words: hits };
    }
};
console.log("EternalGuard Engine v1.1 - Workspace Active");
