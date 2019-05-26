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
        %Mtg.Card{name: name, types: types, cmc: cmc, rulings: rulings, foreign_names: foreign_names, legalities: legalities, multiverseid: multiverseid, id: id} = response_card()

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
        %Mtg.Set{block: block, booster: booster, border: border, mkm_id: mkm_id, release_date: release_date} = response_card()

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
        %Mtg.Card{name: name, types: types, cmc: cmc, rulings: rulings, foreign_names: foreign_names, legalities: legalities, multiverseid: multiverseid, id: id} = response_card()

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
        %Mtg.Set{block: block, booster: booster, border: border, mkm_id: mkm_id, release_date: release_date} = response_set()

        expect block |> to(eq "Core Set")
        expect booster |> to(have_length 16)
        expect border |> to(eq nil)
        expect mkm_id |> to(eq 1234)
        expect release_date |> to(eq ~D[2007-07-13])
      end
    end
  end
end
