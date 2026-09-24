//
//  CatBreedMocks.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

// MARK: - Cat Breed Mocks
/// Local data set used while the breeds endpoint is not available.
public enum CatBreedMocks {

    public static let breeds: [CatBreed] = [
        breed("abys", "Abyssinian", "Egypt", "Active, Energetic, Independent, Intelligent, Gentle", "14 - 15", "0XYvRd7oD",
              "Curious and playful, the Abyssinian loves to explore every corner of the house and stay close to its people."),
        breed("aege", "Aegean", "Greece", "Affectionate, Social, Intelligent, Playful, Active", "9 - 12", "ozEvzdVM-",
              "A natural breed from the Cycladic islands, sociable and fond of water and fishing games."),
        breed("amsh", "American Shorthair", "United States", "Active, Curious, Easy Going, Playful, Calm", "15 - 17", "JFPROfGtQ",
              "A sturdy and adaptable companion that gets along well with children and other pets."),
        breed("bali", "Balinese", "United States", "Affectionate, Intelligent, Playful", "10 - 15", "13MkvUreZ",
              "A long-haired relative of the Siamese, talkative, graceful and very attached to its family."),
        breed("beng", "Bengal", "United States", "Alert, Agile, Energetic, Demanding, Intelligent", "12 - 15", "O3btzLlsO",
              "Wild-looking and athletic, the Bengal needs plenty of play and mental stimulation."),
        breed("birm", "Birman", "Myanmar", "Affectionate, Active, Gentle, Social", "14 - 15", "HOrX5gwLS",
              "Known for its white gloved paws and deep blue eyes, the Birman is calm and people-oriented."),
        breed("bomb", "Bombay", "United States", "Affectionate, Dependent, Gentle, Intelligent, Playful", "12 - 16", "5iYq9NmT1",
              "A sleek black cat with copper eyes that enjoys attention and warm laps."),
        breed("bsho", "British Shorthair", "United Kingdom", "Affectionate, Easy Going, Gentle, Loyal, Patient, Calm", "12 - 17", "s4wQfYoEk",
              "Round-faced and plush-coated, it is an easygoing cat that is content with a quiet routine."),
        breed("bure", "Burmese", "Burma", "Curious, Intelligent, Gentle, Social, Interactive, Playful", "15 - 16", "4lXnnfxac",
              "A compact and muscular cat that behaves almost like a dog, following its owners around."),
        breed("char", "Chartreux", "France", "Affectionate, Loyal, Intelligent, Social, Lively, Playful", "12 - 15", "j6oFGLpRG",
              "A quiet blue-gray cat with a gentle smile, loyal and an excellent hunter of toys."),
        breed("drex", "Devon Rex", "United Kingdom", "Highly interactive, Mischievous, Loyal, Social, Playful", "10 - 15", "4RzEwvyzz",
              "Big ears and a wavy coat give the Devon Rex a pixie look to match its mischievous personality."),
        breed("emau", "Egyptian Mau", "Egypt", "Agile, Dependent, Gentle, Intelligent, Lively, Loyal, Playful", "18 - 20", "TuSyTkt2n",
              "One of the few naturally spotted breeds and among the fastest domestic cats."),
        breed("hbro", "Havana Brown", "United Kingdom", "Affectionate, Curious, Demanding, Friendly, Intelligent, Playful", "10 - 15", "njK25knLH",
              "A chocolate-colored cat that uses its paws to investigate everything around it."),
        breed("hima", "Himalayan", "United States", "Dependent, Gentle, Intelligent, Quiet, Social", "9 - 15", "CDhOtM-Ig",
              "A cross between the Persian and the Siamese, with a long coat and a sweet, relaxed temperament."),
        breed("mcoo", "Maine Coon", "United States", "Adaptable, Intelligent, Loving, Gentle, Independent", "12 - 15", "OOD3VXAQn",
              "One of the largest domestic breeds, known as a gentle giant with a thick, water-resistant coat."),
        breed("manx", "Manx", "Isle of Man", "Easy Going, Intelligent, Loyal, Playful, Social", "12 - 14", "fhYh2PDcC",
              "Famous for being tailless, the Manx is a skilled jumper and a devoted companion."),
        breed("norw", "Norwegian Forest Cat", "Norway", "Sweet, Active, Intelligent, Social, Playful, Lively, Curious", "12 - 16", "06dgGmEOV",
              "A strong climber with a double coat built for Scandinavian winters."),
        breed("ocic", "Ocicat", "United States", "Active, Agile, Curious, Demanding, Friendly, Gentle, Lively, Playful", "12 - 14", "JAx-08Y0n",
              "Looks like a wild cat but has no wild ancestry; outgoing and easy to train."),
        breed("pers", "Persian", "Iran (Persia)", "Affectionate, Loyal, Sedate, Quiet", "14 - 15", "-Zfz5z2jK",
              "A calm and dignified breed with a long, luxurious coat that needs daily grooming."),
        breed("ragd", "Ragdoll", "United States", "Affectionate, Friendly, Gentle, Quiet, Easygoing", "12 - 17", "oGefY4YoG",
              "Named for its habit of going limp when held, the Ragdoll is large, docile and affectionate."),
        breed("rblu", "Russian Blue", "Russia", "Active, Dependent, Easy Going, Gentle, Intelligent, Loyal, Playful, Quiet", "10 - 16", "Rhj-JsTFu",
              "A reserved cat with a shimmering silver-blue coat that bonds strongly with its family."),
        breed("sava", "Savannah", "United States", "Curious, Social, Intelligent, Loyal, Outgoing, Adventurous, Affectionate", "17 - 20", "a8nIYvs6S",
              "A tall and energetic hybrid that can learn to walk on a leash and play fetch."),
        breed("sfol", "Scottish Fold", "United Kingdom", "Affectionate, Intelligent, Loyal, Playful, Social, Sweet, Loving", "11 - 14", "o9t0LDcsa",
              "Recognizable by its folded ears, this breed is sweet-natured and adapts easily to new places."),
        breed("siam", "Siamese", "Thailand", "Active, Agile, Clever, Sociable, Loving, Energetic", "12 - 15", "ai6Jps4sx",
              "Vocal and social, the Siamese wants to be involved in everything its humans do."),
        breed("sphy", "Sphynx", "Canada", "Loyal, Inquisitive, Friendly, Quiet, Gentle", "12 - 14", "BDb8ZXb1v",
              "A hairless breed with a warm, suede-like skin and an extremely affectionate personality.")
    ]

    /// Returns the slice of `breeds` for a zero-based page, mirroring the API pagination.
    static func slice(page: Int, limit: Int) -> [CatBreed] {
        guard page >= 0, limit > 0 else {
            return []
        }
        let start = page * limit
        guard start < breeds.count else {
            return []
        }
        return Array(breeds[start..<min(start + limit, breeds.count)])
    }

    static func pageData(page: Int, limit: Int) -> Data {
        (try? JSONEncoder().encode(slice(page: page, limit: limit))) ?? Data()
    }

    private static func breed(
        _ id: String,
        _ name: String,
        _ origin: String,
        _ temperament: String,
        _ lifeSpan: String,
        _ imageId: String,
        _ description: String
    ) -> CatBreed {
        CatBreed(
            id: id,
            name: name,
            description: description,
            origin: origin,
            temperament: temperament,
            lifeSpan: lifeSpan,
            referenceImageId: imageId,
            image: CatImage(id: imageId, url: URL(string: "https://cdn2.thecatapi.com/images/\(imageId).jpg"))
        )
    }
}
