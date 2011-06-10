package pl.goldmann.confitura.beans;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.UserTransaction;
import pl.goldmann.confitura.model.Tweet;

@ApplicationScoped
public class TweetSaver {

    @Inject
    private UserTransaction tx;
    @PersistenceContext(unitName = "ConfituraPU")
    private EntityManager entityManager;

    public void save(String username, String message, Long id) throws Exception {

        Tweet t = new Tweet();
        t.setId(id);
        t.setMessage(message);
        t.setUsername(username);

        try {
            tx.begin();
            entityManager.persist(t);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }

            throw e;
        }
    }
}
