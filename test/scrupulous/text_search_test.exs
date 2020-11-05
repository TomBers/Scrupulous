defmodule Scrupulus.TextSearchTest do

  use Scrupulous.DataCase

  describe "test search works correctly" do
    test "can find simple phrase" do
      book = sample_book()

      res = Store.search_in_book(book, "On the screen, a news commentator was")
      len = length(res)
      assert len == 1
    end

    test "can find phrase split over multiple lines" do
      book = sample_book()

      res = Store.search_in_book(book, "where they had been seeking that 2185 A.D. rarity")
      len = length(res)
      assert len == 1
    end

    test "can find full paragraph" do
      book = sample_book()

      res = Store.search_in_book(book, "Gramps Ford, his chin resting on his hands, his hands on the crook of his cane, was staring irascibly at the five-foot television screen that dominated the room. On the screen, a news commentator was summarizing the day's happenings.")
      len = length(res)
      assert len == 1
    end

  end

  def sample_book do
    [
      {
        0,
        "\uFEFFThe Project Gutenberg EBook of The Big Trip Up Yonder, by Kurt Vonnegut\r"
      },
      {1, "This eBook is for the use of anyone anywhere at no cost and with\r"},
      {2, "almost no restrictions whatsoever.  You may copy it, give it away or\r"},
      {3, "re-use it under the terms of the Project Gutenberg License included\r"},
      {4, "with this eBook or online at www.gutenberg.net\r"},
      {5, "Title: The Big Trip Up Yonder\r"},
      {6, "Author: Kurt Vonnegut\r"},
      {7, "Illustrator: Kossin\r"},
      {8, "Release Date: October 13, 2009 [EBook #30240]\r"},
      {9, "Language: English\r"},
      {10, "*** START OF THIS PROJECT GUTENBERG EBOOK THE BIG TRIP UP YONDER ***\r"},
      {11, "Produced by Greg Weeks, Stephen Blundell and the Online\r"},
      {12, "Distributed Proofreading Team at http://www.pgdp.net\r"},
      {13, " THE BIG TRIP\r"},
      {14, "       UP YONDER\r"},
      {15, "By KURT VONNEGUT, JR.\r"},
      {16, "Illustrated by KOSSIN\r"},
      {17, "    _If it was good enough for your grandfather, forget it ... it is\r"},
      {18, "    much too good for anyone else!_\r"},
      {
        19,
        "Gramps Ford, his chin resting on his hands, his hands on the crook of\r"
      },
      {
        20,
        "his cane, was staring irascibly at the five-foot television screen that\r"
      },
      {
        21,
        "dominated the room. On the screen, a news commentator was summarizing\r"
      },
      {
        22,
        "the day's happenings. Every thirty seconds or so, Gramps would jab the\r"
      },
      {
        23,
        "floor with his cane-tip and shout, \"Hell, we did that a hundred years\r"
      },
      {24, "ago!\"\r"},
      {
        25,
        "Emerald and Lou, coming in from the balcony, where they had been seeking\r"
      },
      {
        26,
        "that 2185 A.D. rarity--privacy--were obliged to take seats in the back\r"
      },
      {
        27,
        "row, behind Lou's father and mother, brother and sister-in-law, son and\r"
      },
      {28, "daughter-in-law, grandson and wife, granddaughter and husband,\r"},
      {29, "great-grandson and wife, nephew and wife, grandnephew and wife,\r"},
      {30, "great-grandniece and husband, great-grandnephew and wife--and, of\r"},
      {
        31,
        "course, Gramps, who was in front of everybody. All save Gramps, who was\r"
      },
      {
        32,
        "somewhat withered and bent, seemed, by pre-anti-gerasone standards, to\r"
      },
      {33, "be about the same age--somewhere in their late twenties or early\r"},
      {34, "thirties. Gramps looked older because he had already reached 70 when\r"},
      {35, "anti-gerasone was invented. He had not aged in the 102 years since.\r"},
      {
        36,
        "\"Meanwhile,\" the commentator was saying, \"Council Bluffs, Iowa, was\r"
      },
      {37, "still threatened by stark tragedy. But 200 weary rescue workers have\r"},
      {
        38,
        "refused to give up hope, and continue to dig in an effort to save Elbert\r"
      },
      {39, "Haggedorn, 183, who has been wedged for two days in a ...\"\r"},
      {
        40,
        "\"I wish he'd get something more cheerful,\" Emerald whispered to Lou.\r"
      },
      {41, "       *       *       *       *       *\r"},
      {
        42,
        "\"Silence!\" cried Gramps. \"Next one shoots off his big bazoo while the\r"
      },
      {43, "TV's on is gonna find hisself cut off without a dollar--\" his voice\r"},
      {
        44,
        "suddenly softened and sweetened--\"when they wave that checkered flag at\r"
      },
      {
        45,
        "the Indianapolis Speedway, and old Gramps gets ready for the Big Trip Up\r"
      },
      {46, "Yonder.\"\r"},
      {
        47,
        "He sniffed sentimentally, while his heirs concentrated desperately on\r"
      }
    ]
  end

end