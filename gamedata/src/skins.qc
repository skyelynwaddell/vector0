// Skin Set Type
typedef struct SkinSet {
    int id;         // Skin Set ID (Matches SKIN_SET enum)
    string name;    // The readable name for the set printed in game
} SkinSet;

// Skin Type
typedef struct Skin {
    int set_id;         // refers to the Skin's SkinSet ID
    string filepath;    // the full filepath to the skin file (ie. "skins/set1/9mm_toxic.skin")
} Skin;

// SkinSet Index, is the order of `skin_sets` array
SkinSet skin_sets[100];
enum SKIN_SET {
    SKIN_SET_NONE=0,
    SKIN_SET_TEST=1,
};

// Skins
Skin SKIN_DEFAULT;
Skin SKIN_TOXIC;

/*
SkinsInit
Called once when the game is started 
to intialize all skins, and skin sets.
* Define your Set & Skins contents here... *
*/
void SkinsInit()
{
    // ================================================
    // --- Set None ---
    skin_sets[SKIN_SET_NONE].id = SKIN_SET_NONE;
    skin_sets[SKIN_SET_NONE].name = "Set None";

    SKIN_DEFAULT.set_id = SKIN_SET_NONE;
    SKIN_DEFAULT.filepath = __NULL__;
    // ================================================


    // ================================================
    // --- Set One ---
    skin_sets[SKIN_SET_TEST].id = SKIN_SET_TEST;
    skin_sets[SKIN_SET_TEST].name = "Set #1";

    SKIN_TOXIC.set_id = SKIN_SET_TEST;
    SKIN_TOXIC.filepath = "skins/set1/9mm_toxic.skin";
    // ================================================
};