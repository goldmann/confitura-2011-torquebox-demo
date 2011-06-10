package pl.goldmann.confitura.beans;

import java.util.List;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.UserTransaction;
import pl.goldmann.confitura.model.Tweet;

@ApplicationScoped
public class TweetRemover {

    @Inject
    private UserTransaction tx;
    @PersistenceContext(unitName = "ConfituraPU")
    private EntityManager entityManager;

    public void remove(int maxResults) throws Exception {

        System.out.println("Removing some long tweets!");
        
        try {
            tx.begin();

            List<Tweet> tweets = (List<Tweet>) entityManager.createQuery("from Tweet t where length(t.message) > 100 order by t.id asc").setMaxResults(maxResults).getResultList();

            for (Tweet tweet : tweets) {
                System.out.println("Removing tweet: " + tweet.getMessage());
                entityManager.remove(tweet);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }

            throw e;
        }
        
        System.out.println("Removal done!");
    }
}
