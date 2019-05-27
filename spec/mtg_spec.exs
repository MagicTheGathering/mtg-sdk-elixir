defmodule MtgSpec do
  use ESpec

  context "when there is an error in the request" do
    before do
      allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/cards", [], [recv_timeout: 30000]) ->
        {:error, %HTTPoison.Error{reason: :closed}}
      end))
    end

    it do
      expect Mtg.list(Card) |> to(eq {:error,  %Mtg.Error{code: nil, message: :closed}})
    end
  end

  context "when response is no success" do
    before do
      allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/cards", [], [recv_timeout: 30000]) ->
        {:ok, %HTTPoison.Response{status_code: 400, body: "{\"status\":400,\"error\":\"We could not process that action\"}"}}
      end))
    end

    it do
      expect Mtg.list(Card, []) |> to(eq {:error,  %Mtg.Error{code: 400, message: "We could not process that action"}})
    end
  end

  context "when response is a success" do
    context "when getting cards" do
      let :headers, do: [{"Count", "1"}, {"Total-Count", 1}]
      let :mtg_response do
        """
        {
          "cards": [
            {
              "name": "Abundance",
              "types": ["Enchantment"],
              "cmc": 4.0,
              "rulings": [
                {
                  "date": "2004-10-04",
                  "text": "This replacement effect replaces the draw, so nothing that triggers on a draw will trigger."
                },
                {
                  "date": "2004-10-04",
                  "text": "If you use this on a multi-card draw, each replaced draw is handled separately. In other words, you reveal and then put on the bottom of the library for the first card, then do the same for the second, and so on. In a multi-card draw you do not have to choose how many of those draws will be replaced before you do any drawing or use of this card."
                }
              ],
              "foreignNames": [
                {
                  "name": "豊穣",
                  "language": "Japanese",
                  "multiverseid": 148019
                },
                {
                  "name":" Abundancia",
                  "language": "Spanish",
                  "multiverseid": 150565
                }
              ],
              "legalities": [
                { "format": "Commander", "legality": "Legal" },
                { "format": "Duel", "legality": "Legal" }
              ],
              "multiverseid": 130483,
              "id": "02ea5ddc89d7847abc77a0fbcbf2bc74e6456559"
            }
          ]
        }
        """
      end
      let :response_card do
        {:ok, %Mtg.Response.Collection{type: "cards", data: data}} = Mtg.list(Card)
        data |> List.first()
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/cards", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, headers: headers(), body: mtg_response()}}
        end))
      end

      it do
        %Mtg.Card{
          name: name,
          types: types,
          cmc: cmc,
          rulings: rulings,
          foreign_names: foreign_names,
          legalities: legalities,
          multiverseid: multiverseid,
          id: id
        } = response_card()

        expect name |> to(eq "Abundance")
        expect types |> to(match_list ["Enchantment"])
        expect cmc |> to(eq 4.0)
        expect rulings |> to(have_length 2)
        expect foreign_names |> to(have_length 2)
        expect legalities |> to(have_length 2)
        expect multiverseid |> to(eq 130483)
        expect id |> to(eq "02ea5ddc89d7847abc77a0fbcbf2bc74e6456559")
      end
    end

    context "when getting sets" do
      let :headers, do: [{"Count", "1"}, {"Total-Count", 1}]
      let :mtg_response do
        """
        {
          "sets": [
            {
              "block": "Core Set",
              "booster": [
                "rare", "uncommon", "uncommon", "uncommon", "common", "common",
                "common", "common", "common", "common", "common", "common",
                "common", "common", "land", "marketing"
              ],
              "border": null,
              "code": "10E",
              "gathererCode": null,
              "magicCardsInfoCode": null,
              "mkm_id": 1234,
              "mkm_name": null,
              "name": "Tenth Edition",
              "oldCode": null,
              "onlineOnly": false,
              "releaseDate": "2007-07-13",
              "type": "core"
            }
          ]
        }
        """
      end
      let :response_card do
        {:ok, %Mtg.Response.Collection{type: "sets", data: data}} = Mtg.list(Set)
        data |> List.first()
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/sets", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, headers: headers(), body: mtg_response()}}
        end))
      end

      it do
        %Mtg.Set{
          block: block,
          booster: booster,
          border: border,
          mkm_id: mkm_id,
          release_date: release_date
        } = response_card()

        expect block |> to(eq "Core Set")
        expect booster |> to(have_length 16)
        expect border |> to(eq nil)
        expect mkm_id |> to(eq 1234)
        expect release_date |> to(eq ~D[2007-07-13])
      end
    end

    context "when getting one card" do
      let :mtg_response do
        """
        {
          "cards": {
            "name": "Abundance",
            "types": ["Enchantment"],
            "cmc": 4.0,
            "rulings": [
              {
                "date": "2004-10-04",
                "text": "This replacement effect replaces the draw, so nothing that triggers on a draw will trigger."
              },
              {
                "date": "2004-10-04",
                "text": "If you use this on a multi-card draw, each replaced draw is handled separately. In other words, you reveal and then put on the bottom of the library for the first card, then do the same for the second, and so on. In a multi-card draw you do not have to choose how many of those draws will be replaced before you do any drawing or use of this card."
              }
            ],
            "foreignNames": [
              {
                "name": "豊穣",
                "language": "Japanese",
                "multiverseid": 148019
              },
              {
                "name":" Abundancia",
                "language": "Spanish",
                "multiverseid": 150565
              }
            ],
            "legalities": [
              { "format": "Commander", "legality": "Legal" },
              { "format": "Duel", "legality": "Legal" }
            ],
            "multiverseid": 130483,
            "id": "02ea5ddc89d7847abc77a0fbcbf2bc74e6456559"
          }
        }
        """
      end
      let :response_card do
        {:ok, card} = Mtg.show(Card, 130483)
        card
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/cards/130483", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        %Mtg.Card{
          name: name,
          types: types,
          cmc: cmc,
          rulings: rulings,
          foreign_names: foreign_names,
          legalities: legalities,
          multiverseid: multiverseid,
          id: id
        } = response_card()

        expect name |> to(eq "Abundance")
        expect types |> to(match_list ["Enchantment"])
        expect cmc |> to(eq 4.0)
        expect rulings |> to(have_length 2)
        expect foreign_names |> to(have_length 2)
        expect legalities |> to(have_length 2)
        expect multiverseid |> to(eq 130483)
        expect id |> to(eq "02ea5ddc89d7847abc77a0fbcbf2bc74e6456559")
      end
    end

    context "when getting one set" do
      let :mtg_response do
        """
        {
          "set": {
            "block": "Core Set",
            "booster": [
              "rare", "uncommon", "uncommon", "uncommon", "common", "common",
              "common", "common", "common", "common", "common", "common",
              "common", "common", "land", "marketing"
            ],
            "border": null,
            "code": "10E",
            "gathererCode": null,
            "magicCardsInfoCode": null,
            "mkm_id": 1234,
            "mkm_name": null,
            "name": "Tenth Edition",
            "oldCode": null,
            "onlineOnly": false,
            "releaseDate": "2007-07-13",
            "type": "core"
          }
        }
        """
      end

      let :response_set do
        {:ok, set} = Mtg.show(Set, "10E")
        set
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/sets/10E", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        %Mtg.Set{
          block: block,
          booster: booster,
          border: border,
          mkm_id: mkm_id,
          release_date: release_date
        } = response_set()

        expect block |> to(eq "Core Set")
        expect booster |> to(have_length 16)
        expect border |> to(eq nil)
        expect mkm_id |> to(eq 1234)
        expect release_date |> to(eq ~D[2007-07-13])
      end
    end

    context "when getting set booster" do
      let :mtg_response do
        """
        {
          "cards": [
            {
              "name": "Mardu Ascendancy",
              "names": [],
              "cmc": 3,
              "colors": [
                "Black",
                "Red",
                "White"
              ],
              "set": "KTK",
              "multiverseid": 386590,
              "rulings": [
                {
                  "date": "2014-09-20",
                  "text": "As the Goblin token enters the battlefield, you choose which opponent or opposing planeswalker it’s attacking. It doesn’t have to attack the same opponent or opposing planeswalker that the original creature is attacking."
                }
              ],
              "foreignNames": [
                {
                  "name": "Vormacht der Mardu",
                  "text": "Immer wenn eine Nichtspielsteinkreatur, die du kontrollierst, angreift, bringe einen 1/1 roten Goblin-Kreaturenspielstein getappt und angreifend ins Spiel. Opfere die Vormacht der Mardu: Kreaturen, die du kontrollierst, erhalten +0/+3 bis zum Ende des Zuges.",
                  "flavor": null,
                  "imageUrl": "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=387397&type=card",
                  "language": "German",
                  "multiverseid": 387397
                }
              ],
              "legalities": [
                {
                  "format": "Commander",
                  "legality": "Legal"
                },
                {
                  "format": "Duel",
                  "legality": "Legal"
                },
                {
                  "format": "Frontier",
                  "legality": "Legal"
                }
              ],
              "id": "8d64da9a-2c5d-5ac7-8d9d-5d8d709607c1"
            }
          ]
        }
        """
      end
      let :response_card do
        {:ok, %Mtg.Response.Collection{type: "cards", data: data}} = Mtg.generate_set_booster("ktk")
        data |> List.first()
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/sets/ktk/booster", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        %Mtg.Card{
          name: name,
          names: names,
          cmc: cmc,
          colors: colors,
          set: set,
          multiverseid: multiverseid,
          rulings: rulings,
          foreign_names: foreign_names,
          legalities: legalities,
          id: id
        } = response_card()

        expect name |> to(eq "Mardu Ascendancy")
        expect names |> to(eq [])
        expect cmc |> to(eq 3.0)
        expect colors |> to(match_list ["Black", "Red", "White"])
        expect set |> to(eq "KTK")
        expect multiverseid |> to(eq 386590)
        expect rulings |> to(have_length 1)
        expect foreign_names |> to(have_length 1)
        expect legalities |> to(have_length 3)
        expect id |> to(eq "8d64da9a-2c5d-5ac7-8d9d-5d8d709607c1")
      end
    end

    context "when getting all types" do
      let :mtg_response do
        """
        {
          "types": [
            "Artifact", "Card", "Conspiracy", "Creature", "Emblem", "Enchantment",
            "Hero", "instant", "Instant", "Land", "Phenomenon", "Plane",
            "Planeswalker", "Scheme", "Sorcery", "Summon", "Tribal", "Vanguard",
            "You’ll"
          ]
        }
        """
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/types", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        {:ok, types} = Mtg.list(Type)

        expect types |> to(have_hd "Artifact")
        expect types |> to(have_last "You’ll")
        expect types |> to(have_length 19)
      end
    end

    context "when getting all subtypes" do
      let :mtg_response do
        """
        {
          "subtypes": [
            "Advisor", "Aetherborn", "Ajani", "Alara", "Ally", "Aminatou"
          ]
        }
        """
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/subtypes", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        {:ok, subtypes} = Mtg.list(Subtype)

        expect subtypes |> to(have_hd "Advisor")
        expect subtypes |> to(have_last "Aminatou")
        expect subtypes |> to(have_length 6)
      end
    end

    context "when getting all supertypes" do
      let :mtg_response do
        """
        {
          "supertypes": ["Basic", "Host", "Legendary", "Ongoing", "Snow", "World"]
        }
        """
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/supertypes", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        {:ok, supertypes} = Mtg.list(Supertype)

        expect supertypes |> to(have_hd "Basic")
        expect supertypes |> to(have_last "World")
        expect supertypes |> to(have_length 6)
      end
    end

    context "when getting all formats" do
      let :mtg_response do
        """
        {
          "formats": [
            "Commander", "Duel", "Frontier", "Future", "Legacy", "Modern",
            "Oldschool", "Pauper", "Penny", "Standard", "Vintage"
          ]
        }
        """
      end

      before do
        allow HTTPoison |> to(accept(:get, fn("https://api.magicthegathering.io/v1/formats", [], [recv_timeout: 30000]) ->
          {:ok, %HTTPoison.Response{status_code: 200, body: mtg_response()}}
        end))
      end

      it do
        {:ok, formats} = Mtg.list(Format)

        expect formats |> to(have_hd "Commander")
        expect formats |> to(have_last "Vintage")
        expect formats |> to(have_length 11)
      end
    end
  end
end
